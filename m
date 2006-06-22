From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 22:55:19 -0400
Message-ID: <449A0697.3090702@torque.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com> <44997F73.7040903@emulex.com> <20060621173329.GZ1630@parisc-linux.org> <44998A34.20202@s5r6.in-berlin.de> <20060621190327.GB1630@parisc-linux.org> <4499C9D2.5090103@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6300 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030545AbWFVC4W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 22:56:22 -0400
In-Reply-To: <4499C9D2.5090103@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James Smart <James.Smart@Emulex.Com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Matthew Wilcox wrote:
> 
>> On Wed, Jun 21, 2006 at 08:04:36PM +0200, Stefan Richter wrote:
>>
>>> What is wrong with the current two-line format?
>>
>>
>> Several things.  The way that it's printed means that simultaneous scans
>> lead to the output getting garbled.
> 
> 
> That's true, but it could be implemented as an atomic operation with
> multiple printks nonetheless. However you are right, layout should not
> be a reason to add locks. Make it one printk, but please keep it
> readable. The inquiry printout is one of the few that people actually
> care for.
> 
>> You're exaggerating.
> 
> 
> On purpose. :-)
> 
>> BTW, here's what a line would look like from sbp2 ...
>>
>> scsi 9:0:0:0: CD-ROM            MATSHITA  UJDA730 DVD/CDRW  1.00 Level: 0 
> 
> 
> Here is another SBP-2 device:
>    Vendor: ST340083  Model: 2A                Rev: 3.01
>    Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
> 
> This may be misleading if "Vendor:" and "Model:" prefixes are stripped.
> 
>> btw, I've always found that "CD-ROM" a little confusing; considering
>> that SPC4 says "CD/DVD device", any objections to changing that string
>> to say "CD/DVD" instead of "CD-ROM"?
> 
> 
> Seems reasonable.

Matthew,
Here are short and long lists that I dug up from
sg3_utils and lsscsi. The long list should adhere
to the SPC-4 pdt names more closely:

static const char * scsi_pdt_strs[] = {
    /* 0 */ "disk",
    "tape",
    "printer",
    "processor",        /* often SAF-TE (seldom scanner) device */
    "write once optical disk",
    /* 5 */ "cd/dvd",
    "scanner",
    "optical memory device",
    "medium changer",
    "communications",
    /* 0xa */ "graphics [0xa]",
    "graphics [0xb]",
    "storage array controller",
    "enclosure services device",
    "simplified direct access device",
    "optical card reader/writer device",
    /* 0x10 */ "bridge controller commands",
    "object based storage",
    "automation/driver interface",
    "0x13", "0x14", "0x15", "0x16", "0x17", "0x18",
    "0x19", "0x1a", "0x1b", "0x1c", "0x1d",
    "well known logical unit",
    "no physical device on this lu",
};

static const char * scsi_short_device_types[] =
{
        "disk   ", "tape   ", "printer", "process", "worm   ", "cd/dvd ",
        "scanner", "optical", "mediumx", "comms  ", "(0xa)  ", "(0xb)  ",
        "storage", "enclosu", "sim dsk", "opti rd", "bridge ", "osd    ",
        "adi    ", "(0x13) ", "(0x14) ", "(0x15) ", "(0x16) ", "(0x17) ",
        "(0x18) ", "(0x19) ", "(0x1a) ", "(0x1b) ", "(0x1c) ", "(0x1e) ",
        "wlun   ", "no dev ",
};

There are no known unknowns ...

Doug Gilbert

