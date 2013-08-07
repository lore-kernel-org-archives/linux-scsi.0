From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 7 Aug 2013 18:20:56 +1000
Message-ID: <CAGRGNgUy86ELDPKcxNsn1eczfHEdr5FW6VeBbxRsJBV5ugAztw@mail.gmail.com>
References: <001301ce9321$f2157760$d6406620$@samsung.com> <1375858203.1359.1.camel@linux-fkkt.site>
 <004901ce9342$27e2e970$77a8bc50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:45155 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3HGIVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 04:21:16 -0400
Received: by mail-qe0-f48.google.com with SMTP id 9so809888qea.7
        for <linux-scsi@vger.kernel.org>; Wed, 07 Aug 2013 01:21:16 -0700 (PDT)
In-Reply-To: <004901ce9342$27e2e970$77a8bc50$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: Oliver Neukum <oliver@neukum.org>, James Bottomley <JBottomley@parallels.com>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, dc395x@twibble.org, James Bottomley <jejb@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Jingoo,

On Wed, Aug 7, 2013 at 5:45 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Wednesday, August 07, 2013 3:50 PM, Oliver Neukum wrote:
>> On Wed, 2013-08-07 at 12:55 +0900, Jingoo Han wrote:
>>
>> > @@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
>> >              */
>> >             dprintkl(KERN_WARNING,
>> >                     "EEProm checksum error: using default values and options.\n");
>> > -           eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
>> > +           eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
>>
>> Hi,
>>
>> if you are fixing these issues please use the proper macros for
>> conversion of endianness.
>
> Then, do you mean the following? :)
>
> -       prom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> +       eprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & le16_to_cpu(0xff));

No.

The issue is that the driver is doing things like this:

eeprom->member[0] = (u8)(CONSTANT & 0xff);
eeprom->member[1] = (u8)(CONSTANT >> 8);

Which is exactly the same as code along the lines of:

eeprom->member = cpu_to_le16(CONSTANT);

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
