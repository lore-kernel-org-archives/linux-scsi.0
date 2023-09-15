Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC4FCD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbjIOWs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbjIOWs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:48:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FFB3C00
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:46:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26005C433C9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 22:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694817967;
        bh=sWS9TWFKEilsF94tumjUHUqa62tRrkpGpK0DwOXl6rI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OLkZUvL33ysUKlK0ZwOAg7WS4UdFk7SPJAGn4rV2i03aKbjRjSDNbBiQMzz/G1CjE
         meSVzX5cBkPbv6gE5T2DlMvVBBSMEpIwVfTwA6mN5adUNkhzvWYV/W1dyLqUUY8ju3
         DDyq1kdUusbUVB2VH6ZD5JYk6NP5AkawZQrLWtuJOHCrIaGttSWQTqwz5eAPmT0VQq
         +/3o+ZLGI7wRYflRGBR1a+hmZDbgm3H9qlHZBVZT5hBIoGvfpDCKqmCxgp8alahnIL
         XeE1NS2HtafjCkLipGi1HVfecZOybd10N7/FdGTdekudN2Veh4cUScyVLe8diemJvo
         /4+fFUfwdM5Rw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0DE23C53BCD; Fri, 15 Sep 2023 22:46:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 22:46:06 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dlemoal@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-IXAxzPcotD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

--- Comment #6 from dlemoal@kernel.org ---
On 9/16/23 07:01, Niklas Cassel wrote:
> On Fri, Sep 15, 2023 at 01:42:18PM -0700, Bart Van Assche wrote:
>> On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
>>> The users loqs and leonshaw helped to narrow it down to this commit:
>>>
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea
>>
>> Damien, can you please take a look?
>>
>=20
> Hello Bart,
>=20
> It seems like:
>
> https://lore.kernel.org/linux-scsi/20230915022034.678121-1-dlemoal@kernel=
.org/
>=20
> Solves the problem.
>=20
> From a quick look at the logs with extra log leves enabled:
> https://pastebin.com/f2LQ8kQD
> it appears that the MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
> command with a non-zero service action issued by scsi_cdl_check() fails,
> and will be added to SCSI EH over and over.

Looks like the vmware emulated scsi cdrom (sr) does not like this command...
While SPC would allow cdroms to support CDL, I do not think we will ever see
that. So we could restrict CDL probe to block devices only. That still does=
 not
explain why the constant retry. The MAINTENANCE_IN /
MI_REPORT_SUPPORTED_OPERATION_CODES failing is expected in most cases so it
should silently move on with cdl probe returning false. My patch is still
needed
as some drives seem to hang on that command.

>=20
>=20
> Kind regards,
> Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
