Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8841DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 27 May 2022 01:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiE0BES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 May 2022 21:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiE0BER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2022 21:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A3FC1EFF
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 18:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024476185F
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 01:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DB5EC34113
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 01:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653613455;
        bh=IKrj8Gvltym5/IKF0Bn0M3jvdYM4wZ2mrxp7pzzj03M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AHq0htcHkMWcUwIKY9xjT8wjR5unv52SWYnWQysgzQqziG1QMSjR4MlZRvIXuAAgE
         X+Zn67APjwgCuTa2GKX1maebyer1HtweGa/LoKorqLbwJkeVdCMB97ASwI7+uLFpZ5
         GxCx+8Lsf9Spt4eVZMyRrqvY/2d2vtSvomkaYxWHUXCIyf2aa7kv2FIRx6c7XNUJt3
         jNZu/TrLJo6IC9xMlAbvSv6R5TkKRdu4iswaTexaAUprAkp48QSoDDmcQIsChOx15B
         8DADdw/8lfCM1256hpUqecBPropYzi8UBdMXOsXsHMCYWmNMCikE9PIF8AGTpeYL8C
         48mdywC9DA+sA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 188ACCC13B0; Fri, 27 May 2022 01:04:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Fri, 27 May 2022 01:04:14 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: charlotte@extrahop.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-215943-11613-VOk2tc2ndQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

charlotte@extrahop.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |charlotte@extrahop.com

--- Comment #2 from charlotte@extrahop.com ---
Created attachment 301055
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301055&action=3Dedit
dmesg with UBSAN traces

we're seeing a similar thing on ubuntu 22.04's 5.15-based kernel (attached
kernel log).

MR_DRV_RAID_MAP ends with a single "struct MR_LD_SPAN_MAP ldSpanMap[1]", bu=
t in
MR_DRV_RAID_MAP_ALL, it is always followed by the field "struct MR_LD_SPAN_=
MAP
ldSpanMap[MAX_LOGICAL_DRIVES_DYN - 1]". Even though the access looks like i=
t's
going off the end, the attached backtraces are accessing MR_DRV_RAID_MAP_AL=
L's
ldSpanMap.

So the attached traces are arguably false positives, but drivers/scsi/megar=
aid
is using an unusual idiom.

i assume if it did "struct MR_LD_SPAN_MAP ldSpanMap[0]", it would not trigg=
er
the warning? but also it seems like in most (all?) of these cases it has ac=
cess
to the MR_DRV_RAID_MAP_ALL anyways. (MR_FW_RAID_MAP and MR_FW_RAID_MAP_ALL =
seem
to be in a similar situation, but I didn't look at it as closely).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
