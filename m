From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH] cmdfilter: extend default read filter
Date: Thu, 26 Jun 2008 17:53:34 +0200
Message-ID: <6cf6b73e0806260853v2c8fb475u2a53bcdf20b8ae70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:58773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbYFZPxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2008 11:53:35 -0400
Received: by fg-out-1718.google.com with SMTP id 19so41590fgg.17
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2008 08:53:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: pjones@redhat.com, dgilbert@interlog.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

2008/6/26 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Fri, 27 Jun 2008 00:08:46 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> On Thu, 26 Jun 2008 17:05:50 +0200
>> "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
>>
>> > 2008/6/26 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
>> > > On Thu, 26 Jun 2008 12:10:25 +0200
>> > > "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
>> > >
>> > >> 2008/6/18 Peter Jones <pjones@redhat.com>:
>> > >> > Douglas Gilbert wrote:
>> > >> >>
>> > >> >> Peter Jones wrote:
>> > >> >>>
>> > >> >>> FUJITA Tomonori wrote:
>> > >> >>>
>> > >> >>>> Well, this changes sg behaviour since sg's allow_ops filter has a
>> > >> >>>> access permission different from blk_verify_command filter's.
>> > >> >>>
>> > >> >>>  >
>> > >> >>>>
>> > >> >>>> I guess that the first thing you need to do is that figuring out a
>> > >> >>>> proper access permission for each command, which sg maintainer, etc
>> > >> >>>> can agree. It's pretty hard and that's the reason why this patch has
>> > >> >>>> not been merged for years, I think.
>> > >> >>>
>> > >> >>> I don't think this logic is sound.
>> > >> >>
>> > >> >> That depends on your viewpoint.
>> > >> >
>> > >> > My viewpoint is this:
>> > >> >
>> > >> > 1) Whether you agree with his reasons or not, Linus made it pretty clear
>> > >> > that he's against removing the command filter (see
>> > >> > http://marc.info/?l=linux-scsi&m=115419945212450&w=2 )
>> > >> > 2) Having different code paths use different filtering code just adds more
>> > >> > confusion.
>> > >> > 3) If we're going to have filtering, it should be configurable on a
>> > >> > per-device basis from userland.
>> > >> >
>> > >> > Which of these do you disagree with?
>> > >> >
>> > >> > [...]
>> > >> >>
>> > >> >> Are per device command filters being proposed?
>> > >> >
>> > >> > Yes, that's what the patch implements.  And it allows the userland to
>> > >> > configure them according to the needs of the hardware.
>> > >>
>> > >> Jens can we add merge this for .27 or does anyone still has objections?
>> > >
>> > > I think that this patch makes sg's permission stricter. So this could
>> > > break the existing user-space applications.
>> > >
>> >
>> > any particular app in mind?
>>
>> No, but there would be some.
>>
>>
>> > for write access it still allows all commands (because there are some
>> > userspace apps tha rely on this).
>>
>> Yeah, I know. But for read access, some commands will be blocked.
>
> I think that it's not a good idea to say "this patch could break
> something but we have no idea about them. So we can merge this."
>
> It's better to loosen scsi_ioctl's permissions to match with sg's
> permission.

agreed.

Jens please apply the attached patch on top of the old one.

---------------------------

This patch adds the commands that the former sg filter allowed for read
access to the cmdfilter to keep userspace apps that rely on them working.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff -upNr linux-2.6.orign/block/cmd-filter.c linux-2.6/block/cmd-filter.c
--- linux-2.6.orign/block/cmd-filter.c	2008-06-26 17:41:20.000000000 +0200
+++ linux-2.6/block/cmd-filter.c	2008-06-26 17:43:23.000000000 +0200
@@ -230,6 +230,7 @@ static void rcf_set_defaults(struct blk_
 	__set_bit(READ_16, filter->read_ok);
 	__set_bit(READ_BUFFER, filter->read_ok);
 	__set_bit(READ_DEFECT_DATA, filter->read_ok);
+	__set_bit(READ_CAPACITY, filter->read_ok);
 	__set_bit(READ_LONG, filter->read_ok);
 	__set_bit(INQUIRY, filter->read_ok);
 	__set_bit(MODE_SENSE, filter->read_ok);
@@ -238,6 +239,10 @@ static void rcf_set_defaults(struct blk_
 	__set_bit(START_STOP, filter->read_ok);
 	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
 	__set_bit(VERIFY_16, filter->read_ok);
+	__set_bit(REPORT_LUNS, filter->read_ok);
+	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
+	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
+	__set_bit(MAINTENANCE_IN_CMD, filter->read_ok);
 	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);

 	/* Audio CD commands */
