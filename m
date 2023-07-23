Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BF9C001DE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 18:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjGWSO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 14:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGWSOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 14:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24084E65
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 11:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EEF360C83
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 18:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C83A0C433C9
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690136060;
        bh=u9KIx2JFTDurEDk/08MscGRNuyJGIc5wA2G+JuYVDzE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kKNaHOl7YUA4TJI1hbIx+ygaZ2dFXjedYha+KPWqN7rIHyBGA7cl5RI7FbCMPiDR7
         EhTJ2+pJLlK848XbYQ11E4XmOfPZTc+hxY3lfBnFd0GiMEwd19sCyidOlfGmYRuD19
         YGbnZfxn7haa0SrXR7duP1UrEItaBV6H+ev6MmvTRN7qZJeb79JY6O8o51UvEhIoB2
         mHBXACY8IYWHxSw9APxmgxrz2tTaUHeZhYinvhY2utPn0W+FIXpX5a18cFV8k33+V5
         YOk0biHw/ViCKIzVYARiLYjbzsMWpWC0kugAwDOEYccfaPvidmRtO1p3ZjEscmZl26
         3HIHuheyUKUZw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B1E3CC53BD2; Sun, 23 Jul 2023 18:14:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sun, 23 Jul 2023 18:14:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-QgB8VUQPzE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #9 from pheidologeton@protonmail.com ---
Attached is the kernel log during btrfs balance. Additional information: ar=
ch
linux, / on btrfs. The kernel is built from kernel.org, I don't use arch
kernels. I can send the config if needed
[ 3316.617309] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3319.482222] BTRFS info (device dm-0): relocating block group 40045365952=
512
flags data
[ 3329.220422] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3330.759383] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3331.458286] BTRFS info (device dm-0): relocating block group 40044292210=
688
flags data
[ 3344.973440] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 3347.383541] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 3349.321716] BTRFS info (device dm-0): relocating block group 40043218468=
864
flags data
[ 3365.872341] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3368.168591] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3369.726373] BTRFS info (device dm-0): relocating block group 40042144727=
040
flags data
[ 3382.975757] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 3385.968211] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 3386.724714] BTRFS info (device dm-0): relocating block group 40041070985=
216
flags data
[ 3394.540433] BTRFS info (device dm-0): found 2048 extents, stage: move da=
ta
extents
[ 3397.185759] BTRFS info (device dm-0): found 2048 extents, stage: update =
data
pointers
[ 3399.119172] BTRFS info (device dm-0): relocating block group 40039997243=
392
flags data
[ 3407.703926] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3408.814660] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3409.582049] BTRFS info (device dm-0): relocating block group 40038923501=
568
flags data
[ 3419.867057] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 3422.106158] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 3422.938727] BTRFS info (device dm-0): relocating block group 40037849759=
744
flags data
[ 3428.406170] BTRFS info (device dm-0): found 870 extents, stage: move data
extents
[ 3433.431310] BTRFS info (device dm-0): found 870 extents, stage: update d=
ata
pointers
[ 3437.507903] BTRFS info (device dm-0): relocating block group 40036776017=
920
flags data
[ 3448.653028] BTRFS info (device dm-0): found 1960 extents, stage: move da=
ta
extents
[ 3455.940281] BTRFS info (device dm-0): found 1960 extents, stage: update =
data
pointers
[ 3459.627764] BTRFS info (device dm-0): relocating block group 40035702276=
096
flags data
[ 3468.108075] BTRFS info (device dm-0): found 2059 extents, stage: move da=
ta
extents
[ 3469.458665] BTRFS info (device dm-0): found 2059 extents, stage: update =
data
pointers
[ 3470.245608] BTRFS info (device dm-0): relocating block group 40034628534=
272
flags data
[ 3477.993083] BTRFS info (device dm-0): found 2056 extents, stage: move da=
ta
extents
[ 3479.662803] BTRFS info (device dm-0): found 2056 extents, stage: update =
data
pointers
[ 3481.908411] BTRFS info (device dm-0): relocating block group 40033554792=
448
flags data
[ 3491.709283] BTRFS info (device dm-0): found 2066 extents, stage: move da=
ta
extents
[ 3493.035815] BTRFS info (device dm-0): found 2066 extents, stage: update =
data
pointers
[ 3494.446714] BTRFS info (device dm-0): relocating block group 40032481050=
624
flags data
[ 3505.523295] BTRFS info (device dm-0): found 2062 extents, stage: move da=
ta
extents
[ 3508.145601] BTRFS info (device dm-0): found 2062 extents, stage: update =
data
pointers
[ 3509.167778] BTRFS info (device dm-0): relocating block group 40031407308=
800
flags data
[ 3518.814308] BTRFS info (device dm-0): found 2063 extents, stage: move da=
ta
extents
[ 3520.993505] BTRFS info (device dm-0): found 2063 extents, stage: update =
data
pointers
[ 3522.503043] BTRFS info (device dm-0): relocating block group 40030333566=
976
flags data
[ 3531.751190] BTRFS info (device dm-0): found 2064 extents, stage: move da=
ta
extents
[ 3533.421101] BTRFS info (device dm-0): found 2064 extents, stage: update =
data
pointers
[ 3534.289901] BTRFS info (device dm-0): relocating block group 40029259825=
152
flags data
[ 3542.304610] BTRFS info (device dm-0): found 1901 extents, stage: move da=
ta
extents
[ 3543.452137] BTRFS info (device dm-0): found 1901 extents, stage: update =
data
pointers
[ 3545.360085] BTRFS info (device dm-0): relocating block group 40028186083=
328
flags data
[ 3554.996710] BTRFS info (device dm-0): found 2056 extents, stage: move da=
ta
extents
[ 3558.154072] BTRFS info (device dm-0): found 2056 extents, stage: update =
data
pointers
[ 3559.682636] BTRFS info (device dm-0): relocating block group 40027112341=
504
flags data
[ 3568.657974] BTRFS info (device dm-0): found 2064 extents, stage: move da=
ta
extents
[ 3571.539808] BTRFS info (device dm-0): found 2064 extents, stage: update =
data
pointers
[ 3572.893027] BTRFS info (device dm-0): relocating block group 40026038599=
680
flags data
[ 3583.292919] BTRFS info (device dm-0): found 2061 extents, stage: move da=
ta
extents
[ 3586.633532] BTRFS info (device dm-0): found 2061 extents, stage: update =
data
pointers
[ 3587.914016] BTRFS info (device dm-0): relocating block group 40024964857=
856
flags data
[ 3600.062952] BTRFS info (device dm-0): found 2055 extents, stage: move da=
ta
extents
[ 3602.371266] BTRFS info (device dm-0): found 2055 extents, stage: update =
data
pointers
[ 3603.144455] BTRFS info (device dm-0): relocating block group 40023891116=
032
flags data
[ 3613.895505] BTRFS info (device dm-0): found 2116 extents, stage: move da=
ta
extents
[ 3620.446434] BTRFS info (device dm-0): found 2116 extents, stage: update =
data
pointers
[ 3623.076019] BTRFS info (device dm-0): relocating block group 40022817374=
208
flags data
[ 3631.646738] BTRFS info (device dm-0): found 2077 extents, stage: move da=
ta
extents
[ 3634.235518] BTRFS info (device dm-0): found 2077 extents, stage: update =
data
pointers
[ 3635.573847] BTRFS info (device dm-0): relocating block group 40021743632=
384
flags data
[ 3646.460339] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 3649.351023] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 3650.478747] BTRFS info (device dm-0): relocating block group 40020669890=
560
flags data
[ 3776.018632] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.270455] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.270463] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.270466] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.270468] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.270471] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.286451] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.310451] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.342450] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.362449] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.362453] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.362455] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.378449] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.378452] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.378454] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.378456] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 3784.393980] aacraid: Host bus reset request. SCSI hang ?
[ 3784.393989] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 3784.393991] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 3784.393992] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[ 3784.393994] aacraid 0000:02:00.0: outstanding cmd: firmware-16
[ 3784.393995] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 3784.406273] aacraid 0000:02:00.0: Controller reset type is 3
[ 3784.406275] aacraid 0000:02:00.0: Issuing IOP reset
[ 3818.052903] aacraid 0000:02:00.0: IOP reset succeeded
[ 3818.089560] numacb=3D512 ignored
[ 3818.090077] aacraid: Comm Interface type2 enabled
[ 3831.327204] aacraid 0000:02:00.0: Scheduling bus rescan
[ 3844.356263] sd 10:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 3853.956497] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3864.355224] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3865.992752] BTRFS info (device dm-0): relocating block group 40019596148=
736
flags data
[ 3874.735672] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3878.298428] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3880.455850] BTRFS info (device dm-0): relocating block group 40018522406=
912
flags data
[ 3891.125829] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3893.431071] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3894.271993] BTRFS info (device dm-0): relocating block group 40017448665=
088
flags data
[ 3903.344106] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 3905.644193] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 3906.914578] BTRFS info (device dm-0): relocating block group 40016374923=
264
flags data
[ 3916.797696] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3921.481208] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3924.388232] BTRFS info (device dm-0): relocating block group 40015301181=
440
flags data
[ 3934.062280] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 3936.989412] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 3938.757170] BTRFS info (device dm-0): relocating block group 40014227439=
616
flags data
[ 3947.023461] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 3948.628886] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 3949.501986] BTRFS info (device dm-0): relocating block group 40013153697=
792
flags data
[ 3959.582364] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 3962.158521] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 3962.849216] BTRFS info (device dm-0): relocating block group 40012079955=
968
flags data
[ 3971.717710] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 3972.936642] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 3975.062969] BTRFS info (device dm-0): relocating block group 40011006214=
144
flags data
[ 4101.963623] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963630] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963632] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963635] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963637] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963639] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963641] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963643] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4101.963646] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4102.055618] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4102.055621] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4102.115617] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4102.211615] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4134.726992] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4134.727000] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4144.966793] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4144.978357] aacraid: Host bus reset request. SCSI hang ?
[ 4144.978373] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 4144.978375] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 4144.978377] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[ 4144.978378] aacraid 0000:02:00.0: outstanding cmd: firmware-16
[ 4144.978380] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 4144.994613] aacraid 0000:02:00.0: Controller reset type is 3
[ 4144.994615] aacraid 0000:02:00.0: Issuing IOP reset
[ 4178.492092] aacraid 0000:02:00.0: IOP reset succeeded
[ 4178.517963] numacb=3D512 ignored
[ 4178.518491] aacraid: Comm Interface type2 enabled
[ 4191.766331] aacraid 0000:02:00.0: Scheduling bus rescan
[ 4204.785434] sd 10:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 4206.168041] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 4209.562446] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 4210.236071] BTRFS info (device dm-0): relocating block group 40009932472=
320
flags data
[ 4220.376248] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4222.252717] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4223.045918] BTRFS info (device dm-0): relocating block group 40008858730=
496
flags data
[ 4231.408480] BTRFS info (device dm-0): found 2056 extents, stage: move da=
ta
extents
[ 4233.376778] BTRFS info (device dm-0): found 2056 extents, stage: update =
data
pointers
[ 4236.074206] BTRFS info (device dm-0): relocating block group 40007784988=
672
flags data
[ 4247.118270] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4249.734482] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4251.493058] BTRFS info (device dm-0): relocating block group 40006711246=
848
flags data
[ 4259.821443] BTRFS info (device dm-0): found 2050 extents, stage: move da=
ta
extents
[ 4260.805451] BTRFS info (device dm-0): found 2050 extents, stage: update =
data
pointers
[ 4261.456743] BTRFS info (device dm-0): relocating block group 40005637505=
024
flags data
[ 4271.616724] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4274.831768] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4275.695407] BTRFS info (device dm-0): relocating block group 40004563763=
200
flags data
[ 4285.371736] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 4287.650953] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 4288.171152] BTRFS info (device dm-0): relocating block group 40003490021=
376
flags data
[ 4296.368957] BTRFS info (device dm-0): found 2058 extents, stage: move da=
ta
extents
[ 4303.096606] BTRFS info (device dm-0): found 2058 extents, stage: update =
data
pointers
[ 4308.672345] BTRFS info (device dm-0): relocating block group 40002416279=
552
flags data
[ 4317.848496] BTRFS info (device dm-0): found 2055 extents, stage: move da=
ta
extents
[ 4324.380461] BTRFS info (device dm-0): found 2055 extents, stage: update =
data
pointers
[ 4329.313954] BTRFS info (device dm-0): relocating block group 40001342537=
728
flags data
[ 4340.352759] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 4346.055272] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 4350.341563] BTRFS info (device dm-0): relocating block group 40000268795=
904
flags data
[ 4360.008253] BTRFS info (device dm-0): found 2073 extents, stage: move da=
ta
extents
[ 4363.968894] BTRFS info (device dm-0): found 2073 extents, stage: update =
data
pointers
[ 4366.667086] BTRFS info (device dm-0): relocating block group 39999195054=
080
flags data
[ 4376.714089] BTRFS info (device dm-0): found 2065 extents, stage: move da=
ta
extents
[ 4381.321506] BTRFS info (device dm-0): found 2065 extents, stage: update =
data
pointers
[ 4383.772033] BTRFS info (device dm-0): relocating block group 39998121312=
256
flags data
[ 4392.346068] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4394.681397] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4401.709513] BTRFS info (device dm-0): relocating block group 39997047570=
432
flags data
[ 4415.742970] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4418.352930] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4419.406295] BTRFS info (device dm-0): relocating block group 39995973828=
608
flags data
[ 4427.092182] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4428.429700] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4429.549291] BTRFS info (device dm-0): relocating block group 39994900086=
784
flags data
[ 4440.330092] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4443.546015] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4444.589392] BTRFS info (device dm-0): relocating block group 39993826344=
960
flags data
[ 4452.441851] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4454.065084] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4455.766007] BTRFS info (device dm-0): relocating block group 39992752603=
136
flags data
[ 4466.379938] BTRFS info (device dm-0): found 2055 extents, stage: move da=
ta
extents
[ 4469.010725] BTRFS info (device dm-0): found 2055 extents, stage: update =
data
pointers
[ 4471.997477] BTRFS info (device dm-0): relocating block group 39991678861=
312
flags data
[ 4483.094733] BTRFS info (device dm-0): found 2055 extents, stage: move da=
ta
extents
[ 4485.152335] BTRFS info (device dm-0): found 2055 extents, stage: update =
data
pointers
[ 4486.408387] BTRFS info (device dm-0): relocating block group 39990605119=
488
flags data
[ 4495.974786] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4498.534411] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4499.563931] BTRFS info (device dm-0): relocating block group 39989531377=
664
flags data
[ 4517.353372] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4524.608562] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4527.224028] BTRFS info (device dm-0): relocating block group 39988457635=
840
flags data
[ 4536.621647] BTRFS info (device dm-0): found 2055 extents, stage: move da=
ta
extents
[ 4538.678644] BTRFS info (device dm-0): found 2055 extents, stage: update =
data
pointers
[ 4540.145613] BTRFS info (device dm-0): relocating block group 39987383894=
016
flags data
[ 4550.384635] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4552.970776] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4554.435255] BTRFS info (device dm-0): relocating block group 39986310152=
192
flags data
[ 4563.872637] BTRFS info (device dm-0): found 2051 extents, stage: move da=
ta
extents
[ 4566.764789] BTRFS info (device dm-0): found 2051 extents, stage: update =
data
pointers
[ 4568.159495] BTRFS info (device dm-0): relocating block group 39985236410=
368
flags data
[ 4579.681116] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 4583.466767] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 4586.247517] BTRFS info (device dm-0): relocating block group 39984162668=
544
flags data
[ 4596.054908] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4597.544655] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4598.583901] BTRFS info (device dm-0): relocating block group 39983088926=
720
flags data
[ 4605.907058] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4607.398318] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4608.508892] BTRFS info (device dm-0): relocating block group 39982015184=
896
flags data
[ 4619.110922] BTRFS info (device dm-0): found 2051 extents, stage: move da=
ta
extents
[ 4621.813152] BTRFS info (device dm-0): found 2051 extents, stage: update =
data
pointers
[ 4622.825766] BTRFS info (device dm-0): relocating block group 39980941443=
072
flags data
[ 4630.319726] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4631.692092] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4632.754884] BTRFS info (device dm-0): relocating block group 39979867701=
248
flags data
[ 4645.459829] BTRFS info (device dm-0): found 2052 extents, stage: move da=
ta
extents
[ 4649.317496] BTRFS info (device dm-0): found 2052 extents, stage: update =
data
pointers
[ 4650.643743] BTRFS info (device dm-0): relocating block group 39978793959=
424
flags data
[ 4658.358713] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4659.663771] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4661.089138] BTRFS info (device dm-0): relocating block group 39977720217=
600
flags data
[ 4669.235843] BTRFS info (device dm-0): found 2051 extents, stage: move da=
ta
extents
[ 4670.530009] BTRFS info (device dm-0): found 2051 extents, stage: update =
data
pointers
[ 4671.579253] BTRFS info (device dm-0): relocating block group 39976646475=
776
flags data
[ 4681.371892] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4684.417891] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4686.145066] BTRFS info (device dm-0): relocating block group 39975572733=
952
flags data
[ 4696.044819] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4699.884181] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4702.201894] BTRFS info (device dm-0): relocating block group 39974498992=
128
flags data
[ 4711.594449] BTRFS info (device dm-0): found 2054 extents, stage: move da=
ta
extents
[ 4713.643472] BTRFS info (device dm-0): found 2054 extents, stage: update =
data
pointers
[ 4714.512799] BTRFS info (device dm-0): relocating block group 39973425250=
304
flags data
[ 4722.817900] BTRFS info (device dm-0): found 2057 extents, stage: move da=
ta
extents
[ 4724.101966] BTRFS info (device dm-0): found 2057 extents, stage: update =
data
pointers
[ 4725.202619] BTRFS info (device dm-0): relocating block group 39972351508=
480
flags data
[ 4734.518748] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 4736.529322] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 4737.507277] BTRFS info (device dm-0): relocating block group 39971277766=
656
flags data
[ 4747.890650] BTRFS info (device dm-0): found 2051 extents, stage: move da=
ta
extents
[ 4750.395047] BTRFS info (device dm-0): found 2051 extents, stage: update =
data
pointers
[ 4751.356231] BTRFS info (device dm-0): relocating block group 39970204024=
832
flags data
[ 4881.470732] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470740] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470743] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470745] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470747] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470750] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470752] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470754] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470757] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470758] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470761] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470763] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470764] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470766] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470769] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.470771] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 4881.494268] aacraid: Host bus reset request. SCSI hang ?
[ 4881.494276] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 4881.494278] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 4881.494280] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[ 4881.494282] aacraid 0000:02:00.0: outstanding cmd: firmware-16
[ 4881.494283] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 4881.510554] aacraid 0000:02:00.0: Controller reset type is 3
[ 4881.510556] aacraid 0000:02:00.0: Issuing IOP reset
[ 4915.135236] aacraid 0000:02:00.0: IOP reset succeeded
[ 4915.173754] numacb=3D512 ignored
[ 4915.174291] aacraid: Comm Interface type2 enabled
[ 4928.760752] aacraid 0000:02:00.0: Scheduling bus rescan
[ 4939.400353] BTRFS info (device dm-0): found 2063 extents, stage: move da=
ta
extents
[ 4941.769902] sd 10:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 4943.044681] BTRFS info (device dm-0): found 2063 extents, stage: update =
data
pointers
[ 4945.687414] BTRFS info (device dm-0): relocating block group 39969130283=
008
flags data
[ 4954.864202] BTRFS info (device dm-0): found 2072 extents, stage: move da=
ta
extents
[ 4957.822957] BTRFS info (device dm-0): found 2072 extents, stage: update =
data
pointers
[ 4959.299452] BTRFS info (device dm-0): relocating block group 39968056541=
184
flags data
[ 4968.339907] BTRFS info (device dm-0): found 2073 extents, stage: move da=
ta
extents
[ 4973.463936] BTRFS info (device dm-0): found 2073 extents, stage: update =
data
pointers
[ 4977.130345] BTRFS info (device dm-0): relocating block group 39966982799=
360
flags data
[ 4989.513486] BTRFS info (device dm-0): found 2050 extents, stage: move da=
ta
extents
[ 5001.120554] BTRFS info (device dm-0): found 2050 extents, stage: update =
data
pointers
[ 5010.087463] BTRFS info (device dm-0): relocating block group 39965909057=
536
flags data
[ 5022.123373] BTRFS info (device dm-0): found 2077 extents, stage: move da=
ta
extents
[ 5066.139984] BTRFS info (device dm-0): found 2077 extents, stage: update =
data
pointers
[ 5094.950339] BTRFS info (device dm-0): relocating block group 39964835315=
712
flags data
[ 5107.270236] BTRFS info (device dm-0): found 2065 extents, stage: move da=
ta
extents
[ 5140.991508] BTRFS info (device dm-0): found 2065 extents, stage: update =
data
pointers
[ 5164.250651] BTRFS info (device dm-0): relocating block group 39963761573=
888
flags data
[ 5177.484766] BTRFS info (device dm-0): found 2053 extents, stage: move da=
ta
extents
[ 5201.668181] BTRFS info (device dm-0): found 2053 extents, stage: update =
data
pointers
[ 5227.474665] BTRFS info (device dm-0): relocating block group 39962687832=
064
flags data
[ 5243.028304] BTRFS info (device dm-0): found 2045 extents, stage: move da=
ta
extents
[ 5260.284955] BTRFS info (device dm-0): found 2045 extents, stage: update =
data
pointers
[ 5275.825851] BTRFS info (device dm-0): relocating block group 39961614090=
240
flags data
[ 5289.419014] BTRFS info (device dm-0): found 2069 extents, stage: move da=
ta
extents
[ 5305.187664] BTRFS info (device dm-0): found 2069 extents, stage: update =
data
pointers
[ 5318.520602] BTRFS info (device dm-0): relocating block group 39960540348=
416
flags data
[ 5330.435004] BTRFS info (device dm-0): found 2058 extents, stage: move da=
ta
extents
[ 5338.603566] BTRFS info (device dm-0): found 2058 extents, stage: update =
data
pointers
[ 5343.611832] BTRFS info (device dm-0): balance: canceled
[ 5439.752346] BTRFS info (device dm-0): balance: start -dusage=3D90
[ 5439.755515] BTRFS info (device dm-0): relocating block group 40088315625=
472
flags data
[ 5565.485701] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485708] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485710] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485712] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485714] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485716] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485719] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485721] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485723] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485725] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485727] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485729] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485731] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485732] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485734] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.485736] aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,0,0,0):
[ 5565.504649] aacraid: Host bus reset request. SCSI hang ?
[ 5565.504658] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 5565.504661] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 5565.504662] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[ 5565.504664] aacraid 0000:02:00.0: outstanding cmd: firmware-16
[ 5565.504665] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 5565.521936] aacraid 0000:02:00.0: Controller reset type is 3
[ 5565.521937] aacraid 0000:02:00.0: Issuing IOP reset
[ 5584.653112] INFO: task btrfs:41548 blocked for more than 120 seconds.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
