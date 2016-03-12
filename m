From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Sat, 12 Mar 2016 13:43:02 +0800
Message-ID: <CAGnHSE=0qB2NyMxRu3Y+8VjJ-Ee7a3_O3qjprCEtfGg69dPnOg@mail.gmail.com>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
	<CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
	<yq1bn6lkx71.fsf@sermon.lab.mkp.net>
	<CAGnHSEn-5=nzryFJ6wZU+f82kHqf6LJLfi6LbWCyq+qd+E1TWQ@mail.gmail.com>
	<yq1vb4sk7z1.fsf@sermon.lab.mkp.net>
	<CAGnHSEkOpGGsecC8hL4Sbygrz1Cg+tR3EhZ7dOJcwp82+XgEDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33038 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbcCLFnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2016 00:43:04 -0500
Received: by mail-yw0-f193.google.com with SMTP id g6so7380647ywb.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 21:43:03 -0800 (PST)
In-Reply-To: <CAGnHSEkOpGGsecC8hL4Sbygrz1Cg+tR3EhZ7dOJcwp82+XgEDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

But yeah if it has unmap granularity reported to be, for example, 16,
then it will not be correctly set with min_not_zero().

Wait, shouldn't it be:

max(sdkp->logical_block_size,
   sdkp->unmap_granularity * logical_block_size);

then?


On 12 March 2016 at 13:37, Tom Yan <tom.ty89@gmail.com> wrote:
> Suppose a device has logical block size of 512 bytes and physical
> block size of 4096 bytes ("AF 512e").
>
> If it has unmap granularity reported to be 1, then its discard
> granularity should be 1 * 512 = 512 bytes. However, with max() it is
> set to 4096 bytes instead. With min_not_zero(), it is CORRECTLY set to
> 512 bytes.
>
> If it does not has unmap granularity reported, then with max() its
> discard granularity is set to 4096 bytes. But with min_not_zero(), it
> will ALSO be set to 4096 bytes.
>
> Therefore, I don't see why max() should be used instead according to
> your previous mails.
>
> On 12 March 2016 at 05:41, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>>
>> Tom,
>>
>> Tom> Would min_not_zero() be more proper than max()?
>>
>> That would effectively set discard_granularity to physical_block_size
>> regardless of whether unmap_granularity was provided or not.
>>
>> --
>> Martin K. Petersen      Oracle Linux Engineering
