From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 07 Aug 2013 17:36:32 +0900
Message-ID: <004b01ce9349$3841dfe0$a8c59fa0$@samsung.com>
References: <001301ce9321$f2157760$d6406620$@samsung.com>
 <1375858203.1359.1.camel@linux-fkkt.site>
 <004901ce9342$27e2e970$77a8bc50$@samsung.com>
 <CAGRGNgUy86ELDPKcxNsn1eczfHEdr5FW6VeBbxRsJBV5ugAztw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25976 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab3HGIge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 04:36:34 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR500G62JWGJNE0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 17:36:33 +0900 (KST)
In-reply-to: <CAGRGNgUy86ELDPKcxNsn1eczfHEdr5FW6VeBbxRsJBV5ugAztw@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Julian Calaby' <julian.calaby@gmail.com>
Cc: 'Oliver Neukum' <oliver@neukum.org>, 'James Bottomley' <JBottomley@parallels.com>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, dc395x@twibble.org, 'James Bottomley' <jejb@kernel.org>, 'linux-scsi' <linux-scsi@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>



> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Wednesday, August 07, 2013 5:21 PM
> To: Jingoo Han
> Cc: Oliver Neukum; James Bottomley; Ali Akcaagac; Jamie Lenehan; dc395x@twibble.org; James Bottomley;
> linux-scsi
> Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
> 
> Hi Jingoo,
> 
> On Wed, Aug 7, 2013 at 5:45 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Wednesday, August 07, 2013 3:50 PM, Oliver Neukum wrote:
> >> On Wed, 2013-08-07 at 12:55 +0900, Jingoo Han wrote:
> >>
> >> > @@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
> >> >              */
> >> >             dprintkl(KERN_WARNING,
> >> >                     "EEProm checksum error: using default values and options.\n");
> >> > -           eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> >> > +           eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
> >>
> >> Hi,
> >>
> >> if you are fixing these issues please use the proper macros for
> >> conversion of endianness.
> >
> > Then, do you mean the following? :)
> >
> > -       prom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> > +       eprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & le16_to_cpu(0xff));
> 
> No.
> 
> The issue is that the driver is doing things like this:
> 
> eeprom->member[0] = (u8)(CONSTANT & 0xff);
> eeprom->member[1] = (u8)(CONSTANT >> 8);
> 
> Which is exactly the same as code along the lines of:
> 
> eeprom->member = cpu_to_le16(CONSTANT);

However, when I compile the following, it makes build error.

-               eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
-               eeprom->sub_vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
+               eeprom->sub_vendor_id = cpu_to_le16(PCI_VENDOR_ID_TEKRAM);

Best regards,
Jingoo Han

