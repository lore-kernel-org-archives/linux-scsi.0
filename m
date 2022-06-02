Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DACEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 16:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiFBQ6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 12:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiFBQ6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 12:58:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6506A2A709
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 09:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A61AB82045
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 16:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4D55C34114
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654189121;
        bh=Ddv7uZJ1L+74JHnEGSYn5V7s3LalqBa+YBa5y66kqz8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DuCD/RHf99jtMtLE7ioC4FGXIcx9ZqbOYGg0jzzHm90ElV9CzI/plu7Q4bZzweGmG
         HQv0ddZWozD+9l9JusMGeP3yuTaYvbvZho271yW54y8hIP0WsrJ74eATptjMBCtZJu
         HqizMCCDuL5Oc5zchwN1GiHQNRHeiAS62GzLvtW4eYgusnPz6/3dLTxRb/2BgDh312
         893DWYIdZIHW60mcyO1o7vSCnzbdbuzhWlcSeUDfmj1MV/g4LT7rd4WRIOerIIlvId
         xDn72j34pzoWlFgmBOaRLuf2Csm4HmF4n4eFRSacEW88ocZyl+3xin8mtBj+0NEicf
         RLjXI0vbXWN6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A51EACC13B3; Thu,  2 Jun 2022 16:58:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216059] Scsi host number of Adaptec RAID controller changes
 upon a PCIe hotplug and re-insert
Date:   Thu, 02 Jun 2022 16:58:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216059-11613-1VzdShcw2R@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216059-11613@https.bugzilla.kernel.org/>
References: <bug-216059-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216059

--- Comment #1 from Sagar (sagar.biradar@microchip.com) ---
(In reply to Sagar from comment #0)
> Created attachment 301088 [details]
> The attachments contain the log files which capture before and after cases
> for a hotplug host number change
>=20
> Summary:
> This issue talks of the smartpqi driver for Adaptec controller, PCIe hotp=
lug
> and the corresponding SCSI host number=20
>=20
>=20
> The Linux message log shows the host number (e.g. [14:2:0:0] storage -
> /dev/sg27) unexpectedly changing when PCIe hot remove is rapidly followed=
 by
> PCIe hot add. The problem appears when the two PCIe events occur in quick
> succession (i.e. less than 2 minutes). Because of the timing factor, the
> issue can appear to be intermittent. The problem has been root caused as a
> kernel issue.
>=20
>=20=20
>=20
> Investigation:
> Kernel (4.18.11-hotplug-patch) debug prints were added in  the
> =E2=80=9Cscsi_add_host( )=E2=80=9D and =E2=80=9Cscsi_remove_host ( )=E2=
=80=9D routines. Per the debug prints
> in the log, the scsi host number is released after the PCIe hot add event,
> which forces the kernel use a different host number.
>=20
> (debug prints)
> Line 48: [ 1811.461055] smartpqi 0000:b3:00.0: Debuggg . . .
> pqi_unregister_scsi function, before scsi_remove_host, shost->host_num=3D=
14=20=20
> //smartpqi requests host num 14 to be removed
> Line 83: [ 2012.125750]  (null): Debuggg . . shost->host_no before
> dev_set_name =3D host15
> Line 84: [ 2012.126709] smartpqi 0000:b3:00.0: Debuggg . . . before
> scsi_add_host, shost->host_num=3D15 //upon hot add, kernel allocates host
> number 15, it should be 14
> Line 132: [ 2014.181784] scsi host14: Debuggg . . in scsi_host_dev_release
> function shost_host_no to be removed =3D 14 //kernel finally frees host n=
umber
> 14, but it=E2=80=99s too late
>=20
>=20=20
>=20
> Conclusion:
> The kernel is not releasing the host number immediately when the smartpqi
> driver calls the scsi_remove_host() routine. If the PCIe cable is added b=
ack
> within 2 minutes, the kernel can unexpectedly return a different host
> number. This can lead to applications accessing the wrong device.
> This is a Linux kernel issue and we will be raising a bugzilla on the lin=
ux
> kernel.
>=20
>=20=20
>=20
> Consequence:
> Application accesses wrong device. Rebooting system may still result in
> wrong host number.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
