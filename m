From: Kashyap Desai <kashyap.satyam@gmail.com>
Subject: Re: megaraid_sas driver bug
Date: Fri, 1 Jul 2016 16:36:22 +0530
Message-ID: <CACdNGpRWi11YG30wJmosEPuRo8DX0kTStsm60Ug5K4014OvRHQ@mail.gmail.com>
References: <loom.20160625T191237-500@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35853 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbcGALHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 07:07:17 -0400
Received: by mail-qk0-f194.google.com with SMTP id r68so19943708qka.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2016 04:06:23 -0700 (PDT)
In-Reply-To: <loom.20160625T191237-500@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geza Lucz <geza@lucz.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Jun 25, 2016 at 10:43 PM, Geza Lucz <geza@lucz.com> wrote:
>
> I don=E2=80=99t know if this is the right place to report this and wh=
ether this is
> more like a Centos kernel issue.
>
> Since Centos 6.8, the megaraid_sas driver seems to be somewhat broken=
 =E2=80=93
> which as I understand is a backport of the up-to-date driver to their=
 kernel
> version. It is still partially usable, but as soon as I need to rebui=
ld an
> array, instead of the scan message at the end I get a bunch of kernel=
 error
> messages. There are so many of these that the kernel logger uses too =
much
> CPU and eventually the log fills up the partition, so the server need=
s to be
> rebooted. So technically I lose all hotplug functionality.
>
> Probably the same thing happens when the array degrades.
>
> I=E2=80=99m sending this report here, because there is absolutely no =
mention of
> similar problems on the internet, yet the problem is fully reproducib=
le and
> real.
>
> I=E2=80=99m using Dell Perc 6i at the moment.
>
> Thanks


As we discussed, this is regression and found the proposed fix. Can
you try below patch. ?


---
 megaraid_sas_base.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
index d15e252..bee0895 100755
--- a/megaraid_sas_base.c
+++ b/megaraid_sas_base.c
@@ -5309,6 +5309,12 @@ megasas_get_pd_list(struct megasas_instance *ins=
tance)
     struct MR_PD_ADDRESS *pd_addr;
     dma_addr_t ci_h =3D 0;

+    if (instance->pd_list_not_supported) {
+        dev_info(&instance->pdev->dev, "MR_DCMD_PD_LIST_QUERY "
+            "not supported by firmware\n");
+        return ret;
+    }
+
     cmd =3D megasas_get_cmd(instance);

     if (!cmd) {
--=20


We have verified on our local setup, but waiting for more testing by
Test team to make sure it is good to post.

Thanks, Kashyap

>
>
> Jun 25 08:49:29 ns8 kernel: [  757.358015] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.379016] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.400018] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.421021] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.442017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.463015] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.484021] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.505017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:29 ns8 kernel: [  757.526021] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.547017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.568021] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.589017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.610017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.631017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.652017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.673016] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.694017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.715016] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.736017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.757017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.778017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.799017] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.820018] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.841018] megaraid_sas 0000:02:00.0:=
 DCMD
> failed/not supported by firmware: megasas_get_pd_list 4115
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
