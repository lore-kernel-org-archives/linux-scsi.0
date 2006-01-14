From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: FW drive has incorrect size
Date: Sat, 14 Jan 2006 21:20:59 +0100
Message-ID: <43C95D2B.9000104@s5r6.in-berlin.de>
References: <DC0427D0-BD6B-4E50-B4D0-701A22E5CFD6@n5faz.org> <43C40FE1.7020401@s5r6.in-berlin.de> <D14749C1-E99A-454B-A36D-40B1E63794E0@n5faz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-admin@lists.sourceforge.net>
In-Reply-To: <D14749C1-E99A-454B-A36D-40B1E63794E0@n5faz.org>
Sender: linux1394-user-admin@lists.sourceforge.net
Errors-To: linux1394-user-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-user>
To: paul launspach <paul@n5faz.org>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

paul launspach wrote:
> i tried another host adapter, this one using a via chip. i no longer  
> get any of the Current sense key messages and all drives i try will  
> mount fine but if i do any large reads or writes to the drive i get
> a kernel panic.

There is one sbp2 patch in Linux 2.6.15 which is to fix an oops after 
transient transport errors during data transfers:
"sbp2_command_orb_lock must be held when accessing the _orb_inuse list"
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=963f48a116bf3b797fe184e74c79c50de1da70bb

If this helps, there may be further underlying problems which may cause 
transport errors (which we are ...slowly... working on, so I am 
interested to hear about it).

I don't know if the patch "remove sbp2's TYPE_RBC and 10byte handling" 
which I mentioned in the previous post has potential to fix kernel 
panics during larger data transfers; I believe it does not.

...
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[ea003000- 
> ea0037ff]  Max Packet=[2]
> ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting  to 
> setting max_packet_size to 512 bytes
...
> 0000:00:14.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394  
> Host Controller (rev 46) (prog-if 10 [OHCI])

The "suspicious" message shows that this is an older revision of the VIA 
chip which is known to return an unexpected max_packet_size when 
ohci1394 initializes. Other than that, this chip seemed to work OK so far.

...
> the case looks identical the macpower 400plus,  my mac even  identifies 
> it as a macpower device. one chip is clearly marked as
> an oxford semi FW911PLUS-TQ-A, and the USB chip is a PL-2507.
...

I possess the precursor and successor of this MacPower enclosure which 
are based on OXF911 and OXUF922. They work _very_ reliably.
-- 
Stefan Richter
-=====-=-==- ---= -===-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
