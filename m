From: David Brownell <david-b@pacbell.net>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:13:55 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3F6F2DD3.7090206@pacbell.net>
References: <Pine.LNX.4.44.0309220923590.1904-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060909050702050606000209"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309220923590.1904-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060909050702050606000209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> On Mon, 22 Sep 2003, David Brownell wrote:
> 
>>Linus Torvalds wrote:
>>
>>>Interesting data-point: the device is a happy EHCI camper, and is
>>>totally able to read codepage 8 on EHCI.
>>>
>>>However, if I put it behind a USB-1 hub on the EHCI port, I see the
>>>same problems I saw with OHCI.
>>
>>Can you be more clear?
> 
> 
> That is with the exact same external port on the computer, but with an
> added external (old) USB 1 hub in between. I have no idea how the internal
> EHCI logic switching ends up working, so I'll just append the full
> /proc/bus/usb/devices output for you to judge.

In this case, because it's not "EHCI + USB 2.0 hub", it's still using
the OHCI companion controller.  So that wasn't a new case.

Yes, that's awkward to figure out.  "lsusb -t" doesn't know about device
speeds, but I've attached a Perl script (originally from Randy Dunlap)
that shows the usb tree structure more clearly.  (Although it's still
not smart about trimming out some alternate interface settings, which
is why the cdc devices here have multiple "interface 1" entries.)

     [db@xenon]$ usbtree
     /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=usb-ohci/2p, 12M
     /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=usb-ohci/1p, 12M
     /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=usb-ohci/3p, 12M
     /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=usb-ohci/3p, 12M
     /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/3p, 480M
         |__ Port 2: Dev 2, If 0, Class=hub, Driver=hub/4p, 480M
             |__ Port 1: Dev 7, If 0, Class=comm., Driver=CDCEther, 12M
             |__ Port 1: Dev 7, If 1, Class=comm., Driver=CDCEther, 12M
             |__ Port 1: Dev 7, If 1, Class=comm., Driver=CDCEther, 12M
             |__ Port 3: Dev 8, If 0, Class=stor., Driver=usb-storage, 12M
             |__ Port 4: Dev 9, If 0, Class=hub, Driver=hub/4p, 12M
         |__ Port 3: Dev 6, If 0, Class=comm., Driver=CDCEther, 480M
         |__ Port 3: Dev 6, If 1, Class=comm., Driver=CDCEther, 480M
         |__ Port 3: Dev 6, If 1, Class=comm., Driver=CDCEther, 480M
     [db@xenon]$

That's on a 2.4.23-pre host.  The "ehci handling full speed device"
case always involves going through a 480 Mbit/s hub.  If I were to
connect a highspeed-capable device to that dev9 hub, it'd run only
at full speed ... but it would do so through EHCI.

- Dave


--------------060909050702050606000209
Content-Type: text/plain;
 name="usbtree"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbtree"

#!/usr/bin/perl
#
# Reads /proc/bus/usb/devices and selectively lists and/or
# interprets it.
#
# Originally written by Randy Dunlap. 
#

$DEVFILENAME = "/proc/bus/usb/devices";
$PROGNAME = $0;

if (! open (DEVNUM, "<$DEVFILENAME"))
{
	print "$PROGNAME: cannot open '$DEVFILENAME'\n";
	exit 1;
}

while ($line = <DEVNUM>)	# read a text line from DEVNUM
{
	# skip all lines except those that begin with "T:", "S:", "D:" or "I:".
	if (($line !~ "^T:") && ($line !~ "^I:") && ($line !~ "^D:") && ($line !~ "^S:"))
	{
		next;	# to the next line
	}

	chomp $line;		# remove line endings

	# First convert '=' signs to spaces.
	$line =~ tr/=/ /;

	# and convert all '(' and ')' to spaces.
	$line =~ tr/(/ /;
	$line =~ tr/)/ /;

	# split the line at spaces.
	@fields = split / +/, $line;

	if ($line =~ "^T:")
	{
		# split yields: $bus, $level, $parent, $port, $count, $devnum, $speed, $maxchild.

		$bus    = @fields [2];
		$level  = @fields [4];
		$parent = @fields [6];		# parent devnum
		$port   = @fields [8] + 1;	# make $port 1-based
		$count  = @fields [10];
		$devnum = @fields [12];
		$speed  = @fields [14];
		$maxchild = @fields [16];
		$devclass = "?";
		$intclass = "?";
		$driver   = "?";
		$ifnum    = "?";
		$showclass = "?";	# derived from $devclass or $intclass
		$lastif = "?";			# show only first altsetting
		$HCtype = "?";
		next;
	} # end T: line
	elsif ($line =~ "^D:")
	{ # for D: line
		$devclass = @fields [5];
		next;
	}
	elsif ( $line =~ "^S:" )
	{ # for S: line
		if ( $level == 00 && $line =~ "hcd" )
		{
		    $HCtype = @fields [4];
		}
		elsif ( $level == 00 && $line =~ "HCI" )
		{
		    $HCtype = @fields [3];
		}
		next;
	}
	else
	{ # for I: line
		$intclass = @fields [9];
		$ifnum    = @fields [2];
		$driver   = @fields [15];
	} # end I: line

	if (($devclass eq ">ifc") || ($devclass eq "unk."))
	{	# then use InterfaceClass, not DeviceClass
		$showclass = $intclass;
		$show = "interface";
	}
	else
	{	# use DeviceClass
		$showclass = $devclass;
		$show = "device";
	}

	if ($level == 0)
	{
	    # substitute read driver name
	    if ( $HCtype =~ "UHCI-alt" )
	    {
		$HC = "uhci";
	    }
	    elsif ( $HCtype =~ "UHCI" )
	    {
		$HC = "usb-uhci";
	    }
	    elsif ( $HCtype =~ "OHCI" )
	    {
		$HC = "usb-ohci";
	    }
	    else
	    {
		$HC = $HCtype;
	    }

		print sprintf ("/:  Bus $bus.Port $port: Dev $devnum, Class=root_hub, Driver=%s/%sp, %sM\n",
			 $HC, $maxchild, $speed );
	}
	elsif ($show eq "device" || $lastif ne $ifnum)
	{
		$temp = $level;
		while ($temp >= 1)
		{
			print "    ";
			$temp--;
		}

		print sprintf ("|__ Port $port: Dev $devnum, If $ifnum, Class=$showclass, Driver=$driver%s, %sM\n",
			($maxchild == 0) ? "" : ("/" . $maxchild . "p"),
			$speed);
		$lastif = $ifnum;
	}
} # end while DEVNUM

close (DEVNUM);

# END.

--------------060909050702050606000209--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
