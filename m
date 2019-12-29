Return-Path: <SRS0=ggzA=2T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5680AC2D0CE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Dec 2019 18:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A24B20748
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Dec 2019 18:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MZY8/N0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL2S16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Dec 2019 13:27:58 -0500
Received: from mout.gmx.net ([212.227.15.15]:41783 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfL2S16 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Dec 2019 13:27:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1577644069;
        bh=TY9/Wi6dOzTDMgSZrRR7kn9ZDfKoBgg0pOom0IaStwU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=MZY8/N0MJUjVhispRPTGQ8m+oqUwQkYD8yhjMPNsW0+zNIlf2sgXqa/yOwwsNLR8c
         RUs5da1Gg8e5Clu1sm0r7mI0qOJiX/sAT/egWQqj7K0j4WRWIjX09vU8js9xHqGXbG
         MIk0yITdaMNzMqLWT0zfIzH9UzMPrFv3uPXZt4IY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([89.14.126.163]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MKKZ3-1j2u7v48Hn-00LlzI; Sun, 29
 Dec 2019 19:27:49 +0100
Date:   Sun, 29 Dec 2019 19:27:37 +0100
From:   Sebastian Herbszt <herbszt@gmx.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com, dwagner@suse.de,
        bvanassche@acm.org, Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 00/32] [NEW] efct: Broadcom (Emulex) FC Target driver
Message-ID: <20191229192737.0000343a@gmx.de>
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hZOhOG21RtWUCgKqPAMb7pvucubw0RzjiJtGKUjpG3fARGdyTZu
 rpUo2VuvyhW0uHY20BGhwERaitLWG5vZawEW0Ej50SF2UATtpCeQD5OuMaYhFEMFUsMcOHu
 WPLMsTubRdWc3EHyI3nJoAdLlfiftiEeBatWHhfDDvdlBJsuxM95exUDSttMsrYnzkP8f/1
 DrXOjiYdOrQMyz26pN7oA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qRgigZeuAvo=:2MhTUAsz4ae8Kvns4/eeG2
 mN7vhP1NFaRSLv1Dpd9aX4itoi23UPU/OF1h/WNeZ3gnIa/0HbKpno+8fUsOsZmM4sxZ6vxrf
 rjPejJNO4yIQG0UDQnjF4ZQQiBKocRSFHvAo4pa1/Y7Nlnt69iDPI10D9yRo6J1D+6YGBKrsW
 ap3E0hbbYtgmmas5/IOlfZndjyaHHFBsiNWJCECqB/CN7kpG52qBBOV/qc1mNP8sZUS71y/qW
 o9ECBxIsitIqYJkz8EU8cwFYErPZFj0Q8gCVgBmi+yhje1B1CZm14aGd/u2sB6kNwwwjiaDlc
 bV6iwruzw9J+ijGZzEoThJKrw4bt9FI1gPgUOdmxhBKfv4C8w+kEBfxH+d1Spa+tfPIEG1zOY
 dTBoJpJpNQvAx+J+zJLm/Q529WYPvx9wUtY5c7kj9KWYdMCAK1y5NHwDMFP1xd8iG1D97peja
 dIqBC3DnFDAWGFisIV0/p9ONAzzS+GwcmUVnxjp/+DyvpPZNJIOuC0OP5+zZgu11Oeo8iwuN0
 fhxXr5I9uObYvW4yh281ysHv9qEafJJpFqZo+mQvNPBSPRX7qnvyM/GbgIFHDTYnD8uzbwB+n
 YxMpXminv2KRPRf1wWugeS+rmp9yaXRInoL3PqwC3hLddTrp4m4TneEEwIBNwxRVwDn4+9Rb7
 qmm4IWwz6j26Ot8UM6tA+GYivRwNFVbLanm3j0xnIQH2eV0CT+mDtCzL49eStN8oc8ommz+qh
 NW4a1gPrUZRBJuR+kHr1c3m8iI2KORDCNPukfCq9Zi1DzRMpHXf6BTyssqRvWihnNsX3lfyWs
 s8v+kC+b1SvwCXcUaiLHUMqOtsaWCXUQuvpsMVEZ48aG5wNt3XplfPOnDU8eWmHpAg25QcgR9
 HfIcJH9n1daYJs8rU97m4tZjOEZHVN0QBGJR39iZ1HA+UjQ/r4BAcFuSjM5LkNLyFveSIDbcm
 cM3k5RBr8/8hVgxBZ55s/VdIuDHNIQ9fY7UR/gzUz2qOJi7RLAjn5azNRxRyXjCfVnmmESCdn
 cwkQlbOia74RdmlFYorDBDmtpFacl6nbakJMaizKK9rMQDT1HWo7zU9Y7KnHvPmVx95PQ9oeo
 Vtfh7UfHAjqyoMDeh5SFDu+5QSd0NW82DE/llLm0syDhWoIcX58xURMKHKg+e+m48lXaum3PV
 eZLTzPQ4svUbouPdvJqguuMwQEgaZ244RVSkAQWMgPTC6IL4FRwCBQ1dCJ8gWZPoLRaQxdP2e
 C1PAdp7AVOj9lwfQOIqQEEIslHEQEClXlNJ0h/A==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James Smart wrote:
> This patch set is a request to incorporate the new Broadcom
> (Emulex) FC target driver, efct, into the kernel source tree.
>
> The driver source has been Announced a couple of times, the last
> version on 12/18/2018. The driver has been hosted on gitlab for
> review has had contributions from the community.
>   gitlab (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)
>
> The driver integrates into the source tree at the (new)
> drivers/scsi/elx subdirectory.
>
> The driver consists of the following components:
> - A libefc_sli subdirectory: This subdirectory contains a library that
>   encapsulates common definitions and routines for an Emulex SLI-4
>   adapter.
> - A libefc subdirectory: This subdirectory contains a library of
>   common routines. Of major import is a number of routines that
>   implement a FC Discovery engine for target mode.
> - An efct subdirectory: This subdirectory contains the efct target
>   mode device driver. The driver utilizes the above librarys and
>   plugs into the SCSI LIO interfaces. The driver is SCSI only at
>   this time.
>
> The patches populate the libraries and device driver and can only
> be compiled as a complete set.
>
> This driver is completely independent from the lpfc device driver
> and there is no overlap on PCI ID's.
>
> The patches have been cut against the 5.6/scsi-queue branch.
>
> Thank you to those that have contributed to the driver in the past.
>
> Review comments welcome!
>
> -- james
>
>
> V2 modifications:
>
> Contains the following modifications based on prior review comments:
>   Indentation/Alignment/Spacing changes
>   Comments: format cleanup; removed obvious or unnecessary comments;
>     Added comments for clarity.
>   Headers use #ifndef comparing for prior inclusion
>   Cleanup structure names (remove _s suffix)
>   Encapsulate use of macro arguments
>   Refactor to remove static function declarations for static local
> routines Removed unused variables
>   Fix SLI4_INTF_VALID_MASK for 32bits
>   Ensure no BIT() use
>   Use __ffs() in page count macro
>   Reorg to move field defines out of structure definition
>   Commonize command building routines to reduce duplication
>   LIO interface:
>     Removed scsi initiator includes
>     Cleaned up interface defines
>     Removed lio WWN version attribute.
>     Expanded macros within logging macros
>     Cleaned up lio state setting macro
>     Remove __force use
>     Modularized session debugfs code so can be easily replaced.
>     Cleaned up abort task handling. Return after initiating.
>     Modularized where possible to reduce duplication
>     Convert from kthread to workqueue use
>     Remove unused macros
>   Add missing TARGET_CORE build attribute
>   Fix kbuild test robot warnings
>
> Comments not addressed:
>   Use of __packed: not believed necessary
>   Session debugfs code remains. There is not yet a common lio
>     mechanism to replace with.

There seems to be an issue with this version and also the code from
October on my setup. I am running 5.5.0-rc3 but it also happens
on earlier kernel versions.

While shutting down the target after some testing I execute

rmdir /sys/kernel/config/target/efct/10:00:00:90:fa:f0:89:ba/tpgt_0/acls/1=
0:00:00:90:fa:f0:89:bb

but this command never returns and the shutdown script hangs.

The code from August [1] and a refactored version [2] do not exhibit
this problem.

[  245.485090] efct_TPG[0]_LUN[0] - Removed ACL for InitiatorNode: 10:00:0=
0:90:fa:f0:89:bb Mapped LUN: 0
[  245.497691] efct_TPG[0] - Freeing ACL for efct InitiatorNode: 10:00:00:=
90:fa:f0:89:bb Mapped LUN: 0

[  385.687531] sysrq: Show Blocked State
[  385.687547]   task                PC stack   pid father
[  385.687610] efct:0:0        D    0  3241      2 0x80004000
[  385.687615] Call Trace:
[  385.687628]  __schedule+0x28e/0x7a0
[  385.687635]  ? try_to_del_timer_sync+0x45/0x70
[  385.687639]  ? _raw_spin_lock_irqsave+0x14/0x40
[  385.687643]  schedule+0x46/0xb0
[  385.687646]  schedule_timeout+0x118/0x2d0
[  385.687650]  ? __next_timer_interrupt+0xb0/0xb0
[  385.687653]  wait_for_completion_timeout+0x87/0xf0
[  385.687657]  ? wake_up_q+0x90/0x90
[  385.687682]  efct_intr_thread+0x5a/0xa0 [efct]
[  385.687695]  ? efct_device_detach+0x110/0x110 [efct]
[  385.687700]  kthread+0xdc/0x110
[  385.687713]  ? efct_device_detach+0x110/0x110 [efct]
[  385.687716]  ? kthread_park+0xa0/0xa0
[  385.687720]  ret_from_fork+0x2e/0x40
[  385.687726] rmdir           D    0  3368   3365 0x00000000
[  385.687730] Call Trace:
[  385.687735]  __schedule+0x28e/0x7a0
[  385.687739]  schedule+0x46/0xb0
[  385.687742]  schedule_timeout+0x1bd/0x2d0
[  385.687762]  ? efct_lio_close_session+0x3e/0xd0 [efct]
[  385.687780]  ? efct_lio_close_session+0x3e/0xd0 [efct]
[  385.687783]  ? wait_for_completion+0x2a/0xe0
[  385.687786]  wait_for_completion+0x8f/0xe0
[  385.687789]  ? wake_up_q+0x90/0x90
[  385.687820]  core_tpg_del_initiator_node_acl+0x73/0x100 [target_core_mo=
d]
[  385.687827]  ? config_item_put.part.0+0x57/0xe0 [configfs]
[  385.687845]  target_fabric_nacl_base_release+0x20/0x30 [target_core_mod=
]
[  385.687851]  config_item_put.part.0+0x78/0xe0 [configfs]
[  385.687856]  config_item_put+0x11/0x20 [configfs]
[  385.687861]  configfs_rmdir+0x299/0x300 [configfs]
[  385.687866]  vfs_rmdir+0x6a/0x150
[  385.687869]  do_rmdir+0x16d/0x1a0
[  385.687873]  sys_rmdir+0x15/0x20
[  385.687876]  do_fast_syscall_32+0x87/0x280
[  385.687880]  entry_SYSENTER_32+0xaa/0x102
[  385.687884] EIP: 0xb7eebb89
[  385.687888] Code: ff 00 06 fc ff 30 06 fc ff 60 06 fc ff 90 06 fc ff d0=
 06 fc ff 00 07 fc ff 30 07 fc ff 70 07 fc ff 15 06 fc ff 35 06 fc ff 55 <=
06> fc ff 75 06 fc ff 12 06 fc ff 32 06 fc ff 52 06 fc ff 72 06 fc
[  385.687891] EAX: ffffffda EBX: bf9ea909 ECX: 00000000 EDX: bf9ea909
[  385.687893] ESI: bf9e9114 EDI: 00000002 EBP: bf9e9078 ESP: bf9e901c
[  385.687895] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 000002=
92

[1]
https://repo.or.cz/efct-Emulex_FC_Target/sherbszt.git/shortlog/refs/heads/=
v2-20190804
[2]
https://repo.or.cz/efct-Emulex_FC_Target/sherbszt.git/shortlog/refs/heads/=
v2-20191125

Sebastian
