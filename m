From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 15:03:19 +1000
Message-ID: <428EC117.2000405@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:665 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261660AbVEUFDT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 01:03:19 -0400
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Al Viro wrote:
> 	a) TYPE_SDAD renamed to TYPE_RBC and taken to scsi.h
> 	b) in sbp2.c remapping of TYPE_RPB to TYPE_DISK turned off
> 	c) relevant places in midlayer and sd.c taught to accept TYPE_RBC
> 	d) sd.c::sd_read_cache_type() looks into page 6 when dealing with
> TYPE_RBC - these guys have writeback cache flag there and are not guaranteed
> to have page 8 at all.
> 	e) sd_read_cache_type() got an extra sanity check - it checks that
> it got the page it asked for before using its contents.  And screams if
> mismatch had happened.  Rationale: there are broken devices out there that
> are "helpful" enough to go for "I don't have a page you've asked for, here,
> have another one".  For example, PL3507 had been caught doing just that...
> 	f) sbp2 sets sdev->use_10_for_rw and sdev->use_10_for_ms instead
> of bothering to remap READ6/WRITE6/MOD_SENSE, so most of the conversions
> in there are gone now.

Al,
I applied this patch and tested it with a Lava
Firewire-HC enclosure and a Seagate 7200.7 ATA disk.
The enclosure uses a OXFW900-TQ-A bridge chip.

It works ok, with a few wrinkles. MODE SENSE+SELECT
(6) work properly but MODE SENSE(10) responds with
the 6 byte variant response!? If nothing else it
was useful for testing sdparm and sg_modes coping
with such cases.

I will submit a patch for driver/scsi/scsi.c so it
stops saying the device type (in the output of
"cat /proc/scsi/scsi") is "unknown" for RBC devices.

Here is some output from sdparm (version 0.92):

# sdparm /dev/sdd -a
     /dev/sdd: ST380011  A                    [pdt=0xe]
RBC device parameters (RBC) mode page:
 >>> warning: mode page seems malformed, try '--flexible'
   WCD         0  [ def:  0, saved:  0]
   LBS       45310  [ def:45310, saved:45310]
   NLBS        0  [ def:  0, saved:  0]
   P_P         0  [ def:  0, saved:  0]
   READD       0  [ def:  0, saved:  0]
   WRITED      0  [ def:  0, saved:  0]
   FORMATD     0  [ def:  0, saved:  0]
   LOCKD       0  [ def:  0, saved:  0]

# sdparm /dev/sdd -a -f
     /dev/sdd: ST380011  A                    [pdt=0xe]
RBC device parameters (RBC) mode page:
   WCD         0  [ def:  0, saved:  0]
   LBS       512  [ def:512, saved:512]
   NLBS      156301488  [ def:156301488, saved:156301488]
   P_P       254  [ def:254, saved:254]
   READD       0  [ def:  0, saved:  0]
   WRITED      0  [ def:  0, saved:  0]
   FORMATD     0  [ def:  0, saved:  0]
   LOCKD       0  [ def:  0, saved:  0]

# sdparm /dev/sdd -a -6
     /dev/sdd: ST380011  A                    [pdt=0xe]
RBC device parameters (RBC) mode page:
   WCD         0  [ def:  0, saved:  0]
   LBS       512  [ def:512, saved:512]
   NLBS      156301488  [ def:156301488, saved:156301488]
   P_P       254  [ def:254, saved:254]
   READD       0  [ def:  0, saved:  0]
   WRITED      0  [ def:  0, saved:  0]
   FORMATD     0  [ def:  0, saved:  0]
   LOCKD       0  [ def:  0, saved:  0]

# sdparm /dev/sdd -s WCD -6
     /dev/sdd: ST380011  A                    [pdt=0xe]

# echo $?
0

# sdparm /dev/sdd -g WCD -6
WCD         1  [ def:  1, saved:  1]

# sdparm -i /dev/sdd
     /dev/sdb: ST380011  A                    [pdt=0xe]
Device identification VPD page:
   Addressed logical unit:
     id_type: EUI-64 based,  code_set: Binary
       [0x00043b000000071d]

I found that the WCD field and no others could
be changed with sdparm. When other fields were
changed there was no complaint from the device
but a subsequent get showed no change.

This experiment shows that if sd and the mid level rely
on the response from a MODE SENSE (10) without doing a
sanity check, then they will be using corrupted data.

Doug Gilbert
