From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: NAA identifiers with scsi_id
Date: Wed, 16 Jun 2004 09:49:22 -0700
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <OF5191695D.CE9FD0C8-ON88256EB5.005ABA0C-88256EB5.005C57F2@us.ibm.com>
References: <20040615145421.A23070@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040615145421.A23070@beaverton.ibm.com>
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: patmans@us.ibm.com, Hannes Reinecke <hare@suse.de>, hotplug <linux-hotplug-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Can't we just ignore NAA ids and fall back to page 0x80 + inquiry if 
> these are all we will get via page 0x83?  Just having an arbitrary 
number 
> is not very helpful and totally intransparent to the user.

It's extremely helpful if you're trying to figure out where to send a CDB 
so it reaches the same logical unit as a CDB sent to some address from 
another system or at another time from the same system.  In that case, an 
arbitrary but absolutely unique number is all you need.  And that's the 
most important case.

The matter of identifying a logical unit in human terms (maybe, "the old 
Hitachi disk," or "the disk drive I bought last week that is on the left 
end of the rack") is quite a bit more complex; I'd expect to see that in a 
Device Description page rather than the Device Identification (0x83) or 
Unit Serial Number (0x80) page.  That could give you a make and model, the 
serial number stamped on the box, technology, or whatever other 
information a person uses to identify a logical unit.  But I wouldn't use 
it in anything automated.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems


-------------------------------------------------------
This SF.Net email is sponsored by The 2004 JavaOne(SM) Conference
Learn from the experts at JavaOne(SM), Sun's Worldwide Java Developer
Conference, June 28 - July 1 at the Moscone Center in San Francisco, CA
REGISTER AND SAVE! http://java.sun.com/javaone/sf Priority Code NWMGYKND
