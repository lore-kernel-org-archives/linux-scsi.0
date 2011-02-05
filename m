From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 2/4] target: Move subdev release logic into ->release() callback
Date: Sat, 5 Feb 2011 10:16:27 +0100
Message-ID: <AANLkTikVLMUv06un4wGcoHg4tjkOGGaY0tOXXN5hYHRQ@mail.gmail.com>
References: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
	<1296635211-6269-3-git-send-email-nab@linux-iscsi.org>
	<AANLkTikO_5nukkv_9-h0U8uuUzYa9Pxf0mUEBXFAp2Hz@mail.gmail.com>
	<1296767995.902.159.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62390 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1BEJQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Feb 2011 04:16:27 -0500
Received: by iwn9 with SMTP id 9so2954075iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 05 Feb 2011 01:16:27 -0800 (PST)
In-Reply-To: <1296767995.902.159.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Thu, Feb 3, 2011 at 10:19 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Thu, 2011-02-03 at 20:48 +0100, Fubo Chen wrote:
>> On Wed, Feb 2, 2011 at 9:26 AM, Nicholas A. Bellinger
>> [ ... ]
>>
>> How to apply this patch ? This is what I get:
>>
>> # git diff v2.6.38-rc2 | wc
>> =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0
>> # patch -p1 < ../p2.patch
>> patching file drivers/target/target_core_configfs.c
>> Hunk #1 FAILED at 2004.
>> Hunk #2 FAILED at 2847.
>> Hunk #3 succeeded at 2800 (offset -84 lines).
>> 2 out of 3 hunks FAILED -- saving rejects to file
>> drivers/target/target_core_configfs.c.rej
>>
>
> Hi Fubo,
>
> Note that these are all incremental patches against the LIO upstream
> lio-core-2.6.git/linus-38-rc3 tree, and not against the mainline targ=
et
> code.
>
> If you really want to apply these by hand (you should really be using
> git btw ;), then you will need to first apply the series of 24 patche=
s
> against .38-rc2 mainline target code from my
> scsi-post-merge-2.6.git/for-38-rc3-v2 here:
>
> http://marc.info/?l=3Dlinux-scsi&m=3D129632617326015&w=3D2

Hi Nicholas,

How to use git ? With scsi-post-merge-2.6.git/for-38-rc3-v2, I get this=
:

$ git cherry-pick 31747a72e8d02ac2f9fa1198f2fceb9e565025a3
target: Fix top-level configfs_subsystem default_group shutdown breakag=
e
 Author: Nicholas Bellinger <nab@linux-iscsi.org>
 1 files changed, 11 insertions(+), 9 deletions(-)

$ git cherry-pick ba20ac32737242678f1fa80efc92750334fe1720
target: Move core_delete_hba() into ->release() callback
 Author: Nicholas Bellinger <nab@linux-iscsi.org>
 1 files changed, 12 insertions(+), 3 deletions(-)

$ git cherry-pick dae431fdc82508ae37ea9bbaf071713d23224e4a
Automatic cherry-pick failed.  After resolving the conflicts,
mark the corrected paths with 'git add <paths>' or 'git rm <paths>'
and commit the result with:

        git commit -c dae431fdc82508ae37ea9bbaf071713d23224e4a

$ git diff
diff --cc drivers/target/target_core_configfs.c
index 9e74aa1,3715c91..0000000
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@@ -2798,8 -2872,8 +2824,13 @@@ static void target_core_drop_subdev
        struct se_hba *hba;
        struct se_subsystem_api *t;
        struct config_item *df_item;
++<<<<<<< HEAD
 +      struct config_group *dev_cg, *tg_pt_gp_cg;
 +      int i, ret;
++=3D=3D=3D=3D=3D=3D=3D
+       struct config_group *dev_cg, *tg_pt_gp_cg, *dev_stat_grp;
+       int i;
++>>>>>>> dae431f... target: Move subdev release logic into ->release()=
 callback

        hba =3D item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);

What does this mean ?

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
