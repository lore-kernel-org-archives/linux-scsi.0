From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Thu, 28 Oct 2010 21:29:46 +0800
Message-ID: <AANLkTinwHKGkS1psx1+74p2_DZ2tst5Wbpbs4GbdUwf6@mail.gmail.com>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	<4CBBDC19.1090806@cs.wisc.edu>
	<1288040021.5487.826.camel@mulgrave.site>
	<4CC75F42.9030603@cs.wisc.edu>
	<1288134569.19649.5.camel@mulgrave.site>
	<4CC86CF5.1080204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40204 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0J1N3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 09:29:48 -0400
Received: by wwi18 with SMTP id 18so2882630wwi.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 06:29:47 -0700 (PDT)
In-Reply-To: <4CC86CF5.1080204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 2:18 AM, Mike Christie <michaelc@cs.wisc.edu> w=
rote:
> On 10/26/2010 06:09 PM, James Bottomley wrote:
>>
>> On Tue, 2010-10-26 at 18:07 -0500, Mike Christie wrote:
>>>
>>> On 10/25/2010 03:53 PM, James Bottomley wrote:
>>>>
>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>>> index 1de30eb..484b128 100644
>>>> --- a/drivers/scsi/scsi_error.c
>>>> +++ b/drivers/scsi/scsi_error.c
>>>> @@ -1156,51 +1156,40 @@ static int scsi_eh_target_reset(struct Scs=
i_Host
>>>> *shost,
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *work_q,
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *done_q)
>>>> =C2=A0 {
>>>> - =C2=A0 =C2=A0 =C2=A0 struct scsi_cmnd *scmd, *tgtr_scmd, *next;
>>>> - =C2=A0 =C2=A0 =C2=A0 unsigned int id =3D 0;
>>>> - =C2=A0 =C2=A0 =C2=A0 int rtn;
>>>> + =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(tmp_list);
>>>>
>>>> - =C2=A0 =C2=A0 =C2=A0 do {
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tgtr_scmd =3D N=
ULL;
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_e=
ntry(scmd, work_q, eh_entry) {
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (id =3D=3D scmd_id(scmd)) {
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tgtr_scmd =3D scmd;
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!tgtr_scmd)=
 {
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* not one exactly equal; find the next highest
>>>> */
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 list_for_each_entry(scmd, work_q, eh_entry) {
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (scmd_id(scmd)> =C2=A0 id&&
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!tgtr_scmd ||
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scmd_id(tgtr=
_scmd)>
>>>> scmd_id(scmd)))
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 tgtr_scmd =3D scmd;
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!tgtr_scmd)
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* no more commands, that's it */
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
>>>> + =C2=A0 =C2=A0 =C2=A0 list_splice(work_q,&tmp_list);
>>>
>>>
>>> I think I am hitting multiple bugs. One might be with this patch, b=
ut
>>> strangely they both hit __list_add bugs in the scsi eh. I think thi=
s
>>> needs to be list_splice_init().
>>
>> I think that's exactly right ... I keep getting tripped up by the _i=
nit
>> requirements for reusing lists (and list_heads).
>>
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_e=
ntry_safe(scmd, next,&tmp_list, eh_entry)
>>>> {
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (scmd_id(scmd) !=3D id)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>>>> +
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 && =C2=A0 (!scsi_device_online(scmd->device) ||
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtn =3D=3D FAST_IO_FAIL ||
>>>> !scsi_eh_tur(scmd)))
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_eh_finish_cmd(scmd, done_q)=
;
>>>
>>> Because if the target resets work and move all the commands to the
>>> done_q here.
>>>
>>>
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 else
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* push back on work queue for f=
urther
>>>> processing */
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_move(&scmd->eh_entry, work_=
q);
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0return list_empty(work_q);
>>>> =C2=A0 }
>>>
>>>
>>> Then this work_q is showing garbage in it from the splice I think.
>>> Without the list_splice_init I get that trace I cut and pasted in t=
he
>>> other mail when I just force the scsi eh to run the target reset co=
de.
>>>
>>> In the test, the target reset succeeds. The scsi_eh_finish_cmd call
>>> above moves all the cmds to the done_q. But the work_q still has ju=
nk in
>>> it, and so we return that we need to do more work and eventually we=
 end
>>> up running scsi_eh_offline_sdevs which calls scsi_eh_finish_cmd on =
a
>>> command we already moved to the done_q.
>>
>> So does changing to the _init version fix at least the junk done_q
>> problem?
>>
>
> Yeah.
>

Blame me if it is buggy, please.

---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-10-28 21:27:24.000000000 +0800
@@ -1156,51 +1156,42 @@ static int scsi_eh_target_reset(struct S
 				struct list_head *work_q,
 				struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *tgtr_scmd, *next;
+	struct scsi_cmnd *scmd, *next;
 	unsigned int id =3D 0;
 	int rtn;
+	int success;
+	LIST_HEAD(head);

-	do {
-		tgtr_scmd =3D NULL;
-		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (id =3D=3D scmd_id(scmd)) {
-				tgtr_scmd =3D scmd;
-				break;
-			}
-		}
-		if (!tgtr_scmd) {
-			/* not one exactly equal; find the next highest */
-			list_for_each_entry(scmd, work_q, eh_entry) {
-				if (scmd_id(scmd) > id &&
-				    (!tgtr_scmd ||
-				     scmd_id(tgtr_scmd) > scmd_id(scmd)))
-						tgtr_scmd =3D scmd;
-			}
-		}
-		if (!tgtr_scmd)
-			/* no more commands, that's it */
-			break;
+	while (! list_empty(work_q)) {
+		scmd =3D list_entry(work_q->next, struct scsi_cmnd, eh_entry);
+		id =3D scmd_id(scmd);

 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
 						  current->comm, id));
-		rtn =3D scsi_try_target_reset(tgtr_scmd);
-		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (id =3D=3D scmd_id(scmd))
-					if (!scsi_device_online(scmd->device) ||
-					    rtn =3D=3D FAST_IO_FAIL ||
-					    !scsi_eh_tur(tgtr_scmd))
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
-			}
-		} else
+		rtn =3D scsi_try_target_reset(scmd);
+		success =3D (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL);
+		if (! success)
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
 							  " failed target: "
 							  "%d\n",
 							  current->comm, id));
-		id++;
-	} while(id !=3D 0);
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
+			if (scmd_id(scmd) !=3D id)
+				continue;
+			if (! success) {
+				list_move(&scmd->eh_entry, &head);
+				continue;
+			}
+			if (!scsi_device_online(scmd->device) ||
+			    rtn =3D=3D FAST_IO_FAIL ||
+			    !scsi_eh_tur(scmd))
+				scsi_eh_finish_cmd(scmd, done_q);
+			else
+				list_move(&scmd->eh_entry, &head);
+		}
+	}
+	list_splice(&head, work_q);

 	return list_empty(work_q);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
