From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] be2iscsi: Fix bad WARN_ON
Date: Fri, 2 Oct 2015 14:22:40 +0200
Message-ID: <560E7710.8080703@redhat.com>
References: <1443686578-13030-1-git-send-email-joel@jms.id.au>
 <mqdh9mbm1l5.fsf@c203.arch.suse.de>
 <CACPK8XfROyJM_nuZdLEY49HZH+arQjqCmqiKNo+821gMPvCxMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbJBMWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 08:22:43 -0400
In-Reply-To: <CACPK8XfROyJM_nuZdLEY49HZH+arQjqCmqiKNo+821gMPvCxMQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Stanley <joel@jms.id.au>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org

On 2.10.2015 02:52, Joel Stanley wrote:
> On Thu, Oct 1, 2015 at 6:01 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>>> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
>>> index 7a6dbfb..0b87abb 100644
>>> --- a/drivers/scsi/be2iscsi/be_main.c
>>> +++ b/drivers/scsi/be2iscsi/be_main.c
>>> @@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
>>>  {
>>>       WARN_ON(!virtual_address);
>>>       WARN_ON(!physical_address);
>>> -     WARN_ON(!length > 0);
>>> +     WARN_ON(!(length > 0));
>> Why aren't you doing WARN_ON(length <= 0); it's much nicer to read IMHO
> Sure, I'll resend.

length is unsigned, so maybe just (!length) ?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

