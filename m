Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57441C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 16:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbiDGQSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345723AbiDGQRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 12:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A11D0816
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 09:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B312961F49
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 16:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07E8AC385A4
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649348114;
        bh=8SCr5F2m2gYqQuMy4SpbcalgbEGwjFHEeW7NkFDqmns=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AC9ClsS1F7hs/SRf4sNwfFlXbig/RupMco2clVdvo6yG1vX7e+O+AKhW/yyupC4je
         895xyCtahmK8EFl6tZLXocpO//X0KjmhhuKKIa1eBsRm3UVBKFDPXTXOWV1zXsFPZC
         /pGFz/Cd5OcOwNTTTVxDTKwqelT0kgqiWoVUzxx0WySENcRUfasWa77dVHl+fLXBSL
         sxUSYSezL/gCMuySBXgcVH3KIhbBY16JzJQm5bWvfRyDmQh++UDMdYM2QVDr0rFchf
         IRV7PpMv+4kK7h8OlXQS4MGULSGeV79AJ1DhQ7FR+Qw4po4SVZUzXkpNs3kImGpj/G
         c97OzrvC4zgGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DA2D9C05FCE; Thu,  7 Apr 2022 16:15:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Thu, 07 Apr 2022 16:15:13 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215691-11613-Oumhx3l5lp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215691-11613@https.bugzilla.kernel.org/>
References: <bug-215691-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215691

--- Comment #7 from Badalian Slava (slavon.net@gmail.com) ---
no. 5.15.2 have some error./

simple to reproduce variantts -=20
- fio 4k randrw io=3D64 jobs=3D4 aio with direct and sync=3D0/1.=20
- ovirt VM image copy (nfs rdma share for L

Intresting! Write queue IOSTAT size is 64/128 total to all LV. If one LV us=
ed
for expansive copy. I not found where this limit. Now i use multipath betwe=
en
sas and lvm. Its migrate requests and maybe workaround expander restarts.=20


Ideeas for issuer:
1. nr_requests =3D 128 ro in lv?
2. SSD controller trottling or long block TRIM (used UNMAP) waits?
3. SAS3 enclousere -> SAS2 enclousere connection non compatability (sas2 hdd
mot used and offline)
4. sas support_ncq =3D n in driver
5. sas driver phy width and phy count > real phy ports
7. Deadlock/qieie leak in dirver=20



statistic with multipath:

[root@vm2 ~]# iostat -dxmN
Linux 5.17.1-1.el8.elrepo.x86_64 (vm2.dev.obs.group)    07.04.2022=20=20=20=
=20=20
_x86_64_        (16 CPU)

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm=
=20
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme1n1         12,08   48,47      0,07      0,19     0,00     0,00   0,00=
=20=20
0,00    0,13    0,15   0,01     5,61     4,05   0,06   0,35
nvme0n1         45,97   48,41      0,33      0,19     0,00     0,00   0,00=
=20=20
0,00    0,17    0,12   0,01     7,36     3,98   0,29   2,74
sda              0,07    0,18      0,00      0,00     0,01     0,02  17,22=
=20=20
9,63    0,90    3,17   0,00    31,14     7,94   1,88   0,05
sdc             13,05    7,46      0,50      0,10     0,00     0,00   0,00=
=20=20
0,00    0,83    0,78   0,02    38,87    13,86   0,55   1,13
sdd              9,82   21,04      0,43      0,78     0,00     0,00   0,00=
=20=20
0,00    0,82    3,23   0,08    44,53    38,13   0,58   1,80
sde             21,89   31,68      0,77      1,53     0,00     0,00   0,00=
=20=20
0,00    0,91    4,83   0,20    36,17    49,33   0,55   2,96
sdb              4,09    0,76      0,21      0,03     0,00     0,00   0,00=
=20=20
0,00    1,64    1,94   0,01    52,80    34,02   0,55   0,27
sdg             19,64   55,85      0,85      0,60     0,00     0,00   0,00=
=20=20
0,00    1,04    0,20   0,03    44,20    11,04   0,69   5,21
sdh             13,83    2,37      0,72      0,09     0,00     0,00   0,00=
=20=20
0,00    1,54    2,41   0,03    53,05    38,12   0,45   0,72
sdi              2,87    1,24      0,16      0,02     0,00     0,00   0,00=
=20=20
0,00    2,13    1,14   0,01    58,68    18,36   0,72   0,30
sdj             77,70  155,67      3,39      8,39     0,00     0,00   0,00=
=20=20
0,00    1,61    2,77   0,81    44,69    55,19   0,41   9,56
sdf             17,65   38,37      1,07      1,06     0,00     0,00   0,00=
=20=20
0,00    2,32    3,02   0,17    61,79    28,39   0,50   2,80
sdk            443,34  122,42     35,86      2,99     0,00     0,00   0,00=
=20=20
0,00    3,50    3,77   2,03    82,82    25,00   0,34  19,18
sdp              0,01    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00    3,88    0,00   0,00    14,14     0,00   4,03   0,00
sdn              0,01    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   33,76    0,00   0,00    14,08     0,00  33,52   0,02
sdm              0,01    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   32,53    0,00   0,00    14,14     0,00  32,62   0,02
sdl              0,01    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   33,50    0,00   0,00    14,14     0,00  33,60   0,02
sdo              0,01    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   32,14    0,00   0,00    14,14     0,00  32,26   0,02
sdr              0,00    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   35,00    0,00   0,00    14,63     0,00  35,14   0,02
sdq              0,00    0,00      0,00      0,00     0,00     0,00   0,00=
=20=20
0,00   34,30    0,00   0,00    14,63     0,00  34,45   0,02
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02719H    4,04    0,76      0,21      0,03=
=20=20=20=20
3,09     0,26  43,36  25,46    1,90    2,19   0,01    53,47    34,02   0,53=
=20=20
0,26
Samsung_SSD_850_EVO_4TB_S2RRNX0J800093E  443,29  122,42     35,86      2,99=
=20=20
531,96    24,12  54,55  16,46    4,23    5,18   2,53    82,83    25,00   0,=
34=20
19,14
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02715K   13,00    7,46      0,50      0,10=
=20=20=20=20
6,55     0,47  33,50   5,88    0,89    0,95   0,02    39,02    13,86   0,55=
=20=20
1,12
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02719H1    7,13    1,02      0,21      0,0=
3=20=20=20
 0,00     0,00   0,00   0,00    2,97    6,10   0,03    30,29    25,36   0,3=
1=20=20
0,26
Samsung_SSD_850_EVO_4TB_S2RRNX0J800093E1  975,25  146,54     35,86      2,9=
9=20=20=20
 0,00     0,00   0,00   0,00    7,23   12,89   8,96    37,65    20,88   0,1=
7=20
19,14
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02714Y    9,77   21,04      0,43      0,78=
=20=20=20=20
5,19     6,04  34,68  22,30    0,88    3,97   0,10    44,77    38,13   0,58=
=20=20
1,79
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02715K1   19,54    7,93      0,50      0,1=
0=20=20=20
 0,00     0,00   0,00   0,00    1,53    3,50   0,06    25,95    13,04   0,4=
1=20=20
1,12
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02720L   21,84   31,68      0,77      1,53=
=20=20=20
10,10    20,36  31,61  39,12    1,05    6,19   0,26    36,26    49,33   0,5=
5=20=20
2,95
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02714Y1   14,95   27,08      0,43      0,7=
8=20=20=20
 0,00     0,00   0,00   0,00    2,03   13,67   0,41    29,24    29,62   0,4=
2=20=20
1,79
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02717V   17,60   38,37      1,07      1,06=
=20=20=20
13,36    10,93  43,15  22,17    2,71    3,55   0,20    61,97    28,39   0,5=
0=20=20
2,79
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02720L1   31,94   52,04      0,77      1,5=
3=20=20=20
 0,00     0,00   0,00   0,00    2,23   16,53   0,97    24,80    30,03   0,3=
5=20=20
2,95
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02708N   19,59   55,85      0,85      0,60=
=20=20=20
10,11     1,06  34,05   1,86    1,11    0,22   0,04    44,32    11,04   0,6=
9=20=20
5,21
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02717V1   30,96   49,30      1,07      1,0=
6=20=20=20
 0,00     0,00   0,00   0,00    4,85   10,03   0,66    35,23    22,09   0,3=
5=20=20
2,78
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02818K   13,78    2,37      0,72      0,09=
=20=20=20
10,12     0,50  42,33  17,30    1,63    3,14   0,03    53,25    38,12   0,4=
4=20=20
0,71
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02707F    2,82    1,24      0,16      0,02=
=20=20=20=20
1,16     0,11  29,09   8,27    2,55    1,20   0,01    59,74    18,36   0,70=
=20=20
0,29
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02708N1   29,70   56,91      0,85      0,6=
0=20=20=20
 0,00     0,00   0,00   0,00    1,87    0,32   0,08    29,23    10,84   0,6=
0=20=20
5,21
Samsung_SSD_850_EVO_4TB_S2RRNX0J800385N   77,64  155,67      3,39      8,39=
=20=20=20
41,57   112,12  34,87  41,87    2,06    3,67   1,02    44,72    55,19   0,4=
1=20=20
9,57
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02818K1   23,90    2,87      0,72      0,0=
9=20=20=20
 0,00     0,00   0,00   0,00    2,49    7,90   0,08    30,71    31,53   0,2=
7=20=20
0,71
Samsung_SSD_850_EVO_1TB_S3NZNF0JC02707F1    3,97    1,35      0,16      0,0=
2=20=20=20
 0,00     0,00   0,00   0,00    3,81    1,83   0,02    42,37    16,84   0,5=
4=20=20
0,29
Samsung_SSD_850_EVO_4TB_S2RRNX0J800385N1  119,21  267,79      3,39      8,3=
9=20=20=20
 0,00     0,00   0,00   0,00    4,44   10,21   3,57    29,13    32,09   0,2=
5=20=20
9,57
SSDvg-thin_pool_tmeta_rmeta_0    0,00    2,89      0,00      0,01     0,00=
=20=20=20=20
0,00   0,00   0,00    0,00    0,08   0,00     1,33     1,87   0,70   0,20
SSDvg-thin_pool_tmeta_rimage_0   40,46   45,37      0,16      0,18     0,00=
=20=20=20=20
0,00   0,00   0,00    0,11    0,12   0,01     4,00     4,00   0,30   2,55
SSDvg-thin_pool_tmeta_rmeta_1    0,00    2,89      0,00      0,01     0,00=
=20=20=20=20
0,00   0,00   0,00    1,00    0,23   0,00     0,50     1,87   0,71   0,20
SSDvg-thin_pool_tmeta_rimage_1   11,55   45,37      0,05      0,18     0,00=
=20=20=20=20
0,00   0,00   0,00    0,12    0,12   0,01     4,00     4,00   0,03   0,18
SSDvg-thin_pool_tmeta   52,01   45,37      0,20      0,18     0,00     0,00=
=20=20
0,00   0,00    0,12    1,13   0,06     4,00     4,00   0,27   2,60
SSDvg-thin_pool_tdata 1262,58  613,19     44,14     15,61     0,00     0,00=
=20=20
0,00   0,00    6,35   10,48  14,84    35,80    26,06   0,17  32,49
SSDvg-thin_pool-tpool 1262,58  613,19     44,14     15,61     0,00     0,00=
=20=20
0,00   0,00    6,35   10,48  14,84    35,80    26,06   0,17  32,49
SSDvg-1C      1108,51  241,70     40,10      6,57     0,00     0,00   0,00=
=20=20
0,00    6,86   10,65  10,21    37,05    27,85   0,17  22,95
SSDvg-XT        37,99   20,29      1,36      0,46     0,00     0,00   0,00=
=20=20
0,00    6,25    9,41   0,43    36,67    23,39   0,41   2,41
SSDvg-VDI      107,56  321,43      2,31      8,05     0,00     0,00   0,00=
=20=20
0,00    2,54   11,65   4,42    21,99    25,65   0,37  15,99
SSDvg-LINUX     11,54   29,06      0,50      0,50     0,00     0,00   0,00=
=20=20
0,00    5,05    9,43   0,33    44,73    17,72   0,33   1,33
SSDvg-WinShared    1,70    0,71      0,03      0,02     0,00     0,00   0,0=
0=20=20
0,00    0,67    1,18   0,00    20,46    23,46   0,19   0,05



last crash:

[   62.197449] bond0: (slave enp8s0): link status definitely up, 10000 Mbps
full duplex
[   63.132478] igb 0000:04:00.0 eno1: igb: eno1 NIC Link is Up 1000 Mbps Fu=
ll
Duplex, Flow Control: RX
[   65.477098] nvmet: adding nsid 77 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[   65.490135] nvmet: adding nsid 64 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[   65.490194] NFSD: Using nfsdcld client tracking operations.
[   65.503738] nvmet: adding nsid 26 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[   65.510082] NFSD: starting 90-second grace period (net f00000a8)
[   65.531273] nvmet: adding nsid 27 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[   65.531281] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   65.547873] nvmet_rdma: enabling port 2 (192.168.169.202:4420)
[   65.562488] nvmet_rdma: enabling port 1 (192.168.12.202:4420)
[   67.831723] NFSD: all clients done reclaiming, ending NFSv4 grace period
(net f00000a8)
[   94.212180] nvmet: creating controller 1 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[   94.649065] nvmet: creating controller 2 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[   94.954226] nvmet: creating controller 3 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[   94.973184] nvmet: creating controller 4 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[   95.758941] nvmet: creating controller 5 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[58765.051580] perf: interrupt took too long (2531 > 2500), lowering
kernel.perf_event_max_sample_rate to 79000
[91366.766259] perf: interrupt took too long (3207 > 3163), lowering
kernel.perf_event_max_sample_rate to 62000
[125997.828551] perf: interrupt took too long (4023 > 4008), lowering
kernel.perf_event_max_sample_rate to 49000
[166128.976652] perf: interrupt took too long (5030 > 5028), lowering
kernel.perf_event_max_sample_rate to 39000
[245686.179583] perf: interrupt took too long (6401 > 6287), lowering
kernel.perf_event_max_sample_rate to 31000
[361812.366522] nvmet: adding nsid 77 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[361812.390382] nvmet: adding nsid 64 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[361812.414368] nvmet: adding nsid 26 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[361812.438360] nvmet: adding nsid 27 to subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1
[361812.463294] nvmet_rdma: enabling port 2 (192.168.169.202:4420)
[361812.475664] nvmet_rdma: enabling port 1 (192.168.12.202:4420)
[361813.636000] nvmet: creating controller 1 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[361813.888542] nvmet: creating controller 2 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[361813.938978] nvmet: creating controller 3 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[361814.234342] nvmet: creating controller 4 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[361814.372902] nvmet: creating controller 5 for subsystem
nqn.2014-08.org.nvmexpress:nvmf:uuid:058c2966-2a4e-4497-82bb-c553e9974ae1 f=
or
NQN nqn.2008-08.com.starwindsoftware.
[524048.519248] perf: interrupt took too long (8006 > 8001), lowering
kernel.perf_event_max_sample_rate to 24000
[650030.261937] mpt3sas_cm1: SMP command sent to the expander (handle:0x000=
9,
sas_address:0x5003048029c4e13f, physical_port:0x00) has timed out
[650030.299205] sd 9:0:9:0: [sdj] tag#4818 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299205] sd 9:0:2:0: [sdc] tag#8376 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299211] sd 9:0:2:0: [sdc] tag#8376 CDB: Read(10) 28 00 21 f3 f0 98 =
00
00 68 00
[650030.299230] sd 9:0:2:0: [sdc] tag#5269 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299232] sd 9:0:2:0: [sdc] tag#8478 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299235] sd 9:0:2:0: [sdc] tag#5269 CDB: Read(10) 28 00 21 f3 f1 00 =
00
00 18 00
[650030.299235] sd 9:0:2:0: [sdc] tag#8478 CDB: Read(10) 28 00 21 f3 f1 18 =
00
00 80 00
[650030.299235] sd 9:0:2:0: [sdc] tag#8994 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299238] blk_update_request: I/O error, dev sdc, sector 569635072 op
0x0:(READ) flags 0x0 phys_seg 3 prio class 0
[650030.299238] blk_update_request: I/O error, dev sdc, sector 569635096 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299239] sd 9:0:2:0: [sdc] tag#8994 CDB: Read(10) 28 00 21 f3 f1 98 =
00
00 80 00
[650030.299241] blk_update_request: I/O error, dev sdc, sector 569635224 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299359] sd 9:0:2:0: [sdc] tag#8995 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299362] sd 9:0:2:0: [sdc] tag#8995 CDB: Read(10) 28 00 21 f3 f2 18 =
00
00 80 00
[650030.299363] blk_update_request: I/O error, dev sdc, sector 569635352 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299402] sd 9:0:2:0: [sdc] tag#8996 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299404] sd 9:0:2:0: [sdc] tag#8996 CDB: Read(10) 28 00 21 f3 f2 98 =
00
00 80 00
[650030.299405] blk_update_request: I/O error, dev sdc, sector 569635480 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299457] sd 9:0:2:0: [sdc] tag#8997 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299459] sd 9:0:2:0: [sdc] tag#8997 CDB: Read(10) 28 00 21 f3 f3 18 =
00
00 80 00
[650030.299460] blk_update_request: I/O error, dev sdc, sector 569635608 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299496] sd 9:0:2:0: [sdc] tag#8998 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299497] sd 9:0:2:0: [sdc] tag#8998 CDB: Read(10) 28 00 21 f3 f3 98 =
00
00 80 00
[650030.299498] blk_update_request: I/O error, dev sdc, sector 569635736 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299537] sd 9:0:2:0: [sdc] tag#8999 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D0s
[650030.299539] sd 9:0:2:0: [sdc] tag#8999 CDB: Read(10) 28 00 21 f3 f4 18 =
00
00 80 00
[650030.299540] blk_update_request: I/O error, dev sdc, sector 569635864 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299575] blk_update_request: I/O error, dev sdc, sector 569635992 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.299635] blk_update_request: I/O error, dev sdc, sector 569636120 op
0x0:(READ) flags 0x0 phys_seg 16 prio class 0
[650030.323494] sd 9:0:9:0: [sdj] tag#4818 CDB: Write(16) 8a 00 00 00 00 00=
 ac
84 eb 58 00 00 00 18 00 00
[650030.323497] mpt3sas_cm1: log_info(0x31140000): originator(PL), code(0x1=
4),
sub_code(0x0000)
[650030.323501] mpt3sas_cm1: log_info(0x31140000): originator(PL), code(0x1=
4),
sub_code(0x0000)
[650030.323503] mpt3sas_cm1: log_info(0x31140000): originator(PL), code(0x1=
4),
sub_code(0x0000)
[650030.519348] dm-11: writeback error on inode 2147483777, offset 21799923=
712,
sector 1347604072
[650030.662325] dm-11: writeback error on inode 2147483781, offset 42967900=
16,
sector 1571027880
[650030.674222] sd 9:0:1:0: [sdb] Synchronizing SCSI cache
[650030.684396] dm-11: writeback error on inode 2147483781, offset 65451458=
56,
sector 1575415056
[650030.706872] sd 9:0:1:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650030.729288] dm-11: writeback error on inode 2147483781, offset 67471605=
76,
sector 1575779632
[650030.740839] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e100)
[650030.762746] dm-11: writeback error on inode 2147483781, offset 25779388=
416,
sector 1612874784
[650030.785180] mpt3sas_cm1: removing handle(0x000a),
sas_addr(0x5003048029c4e100)
[650030.796517] dm-11: writeback error on inode 2147483781, offset 42961747=
968,
sector 1643824296
[650030.818824] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(0)
[650030.818826] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650030.960255] dm-11: writeback error on inode 5368709250, offset 35856154=
624,
sector 3369673544
[650031.063223] dm-11: writeback error on inode 5368709250, offset
104397578240, sector 3382456816
[650031.073879] dm-11: writeback error on inode 4294967429, offset 70022905=
856,
sector 3150826496
[650031.084393] dm-11: writeback error on inode 4294967429, offset 70631051=
264,
sector 3152012656
[650031.101252] sd 9:0:2:0: [sdc] Synchronizing SCSI cache
[650031.121358] sd 9:0:2:0: [sdc] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.141102] scsi 9:0:2:0: rejecting I/O to dead device
[650031.151235] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e101)
[650031.161150] mpt3sas_cm1: removing handle(0x000b),
sas_addr(0x5003048029c4e101)
[650031.170923] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(1)
[650031.180563] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.211308] sd 9:0:3:0: [sdd] Synchronizing SCSI cache
[650031.220701] sd 9:0:3:0: [sdd] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.239598] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e102)
[650031.249012] mpt3sas_cm1: removing handle(0x000c),
sas_addr(0x5003048029c4e102)
[650031.258293] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(2)
[650031.267451] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.293182] sd 9:0:4:0: [sde] Synchronizing SCSI cache
[650031.302058] sd 9:0:4:0: [sde] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.320215] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e103)
[650031.329730] mpt3sas_cm1: removing handle(0x000d),
sas_addr(0x5003048029c4e103)
[650031.339141] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(3)
[650031.348608] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.380215] sd 9:0:5:0: [sdf] Synchronizing SCSI cache
[650031.389426] sd 9:0:5:0: [sdf] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.407904] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e104)
[650031.417159] mpt3sas_cm1: removing handle(0x000e),
sas_addr(0x5003048029c4e104)
[650031.426307] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(4)
[650031.435338] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.461199] sd 9:0:6:0: [sdg] Synchronizing SCSI cache
[650031.469962] sd 9:0:6:0: [sdg] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.487790] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e105)
[650031.496809] mpt3sas_cm1: removing handle(0x000f),
sas_addr(0x5003048029c4e105)
[650031.505894] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(5)
[650031.515009] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.542197] sd 9:0:7:0: [sdh] Synchronizing SCSI cache
[650031.551256] sd 9:0:7:0: [sdh] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.569621] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e106)
[650031.578948] mpt3sas_cm1: removing handle(0x0010),
sas_addr(0x5003048029c4e106)
[650031.588186] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(6)
[650031.597363] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.622172] sd 9:0:8:0: [sdi] Synchronizing SCSI cache
[650031.631325] sd 9:0:8:0: [sdi] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.649968] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e107)
[650031.659337] mpt3sas_cm1: removing handle(0x0011),
sas_addr(0x5003048029c4e107)
[650031.668576] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(7)
[650031.677754] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650031.687420] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x500304800000007d)
[650031.696718] mpt3sas_cm1: removing handle(0x001d),
sas_addr(0x500304800000007d)
[650031.705997] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(0)
[650031.715244] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650031.735196] sd 9:0:12:0: [sdl] Synchronizing SCSI cache
[650031.744094] sd 9:0:12:0: [sdl] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.762258] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x500304800000006e)
[650031.771515] mpt3sas_cm1: removing handle(0x0016),
sas_addr(0x500304800000006e)
[650031.780774] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(2)
[650031.790027] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650031.812171] sd 9:0:13:0: [sdm] Synchronizing SCSI cache
[650031.821055] sd 9:0:13:0: [sdm] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.839208] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x500304800000006f)
[650031.848475] mpt3sas_cm1: removing handle(0x0017),
sas_addr(0x500304800000006f)
[650031.857734] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(3)
[650031.866983] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650031.893189] sd 9:0:14:0: [sdn] Synchronizing SCSI cache
[650031.902298] sd 9:0:14:0: [sdn] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.920569] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048000000071)
[650031.929816] mpt3sas_cm1: removing handle(0x0018),
sas_addr(0x5003048000000071)
[650031.939066] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(5)
[650031.948272] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650031.970158] sd 9:0:15:0: [sdo] Synchronizing SCSI cache
[650031.979084] sd 9:0:15:0: [sdo] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650031.997229] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048000000072)
[650032.006447] mpt3sas_cm1: removing handle(0x0019),
sas_addr(0x5003048000000072)
[650032.015665] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(6)
[650032.024858] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650032.053132] sd 9:0:16:0: [sdp] Synchronizing SCSI cache
[650032.061992] sd 9:0:16:0: [sdp] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650032.080200] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048000000073)
[650032.089408] mpt3sas_cm1: removing handle(0x001a),
sas_addr(0x5003048000000073)
[650032.098544] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(7)
[650032.107629] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650032.137182] sd 9:0:17:0: [sdq] Synchronizing SCSI cache
[650032.146260] sd 9:0:17:0: [sdq] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650032.165019] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048000000076)
[650032.174315] mpt3sas_cm1: removing handle(0x001b),
sas_addr(0x5003048000000076)
[650032.183463] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(10)
[650032.192554] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650032.218131] sd 9:0:18:0: [sdr] Synchronizing SCSI cache
[650032.227174] sd 9:0:18:0: [sdr] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650032.245925] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048000000077)
[650032.255218] mpt3sas_cm1: removing handle(0x001c),
sas_addr(0x5003048000000077)
[650032.264369] mpt3sas_cm1: enclosure logical id(0x500304800000007f), slot=
(11)
[650032.273474] mpt3sas_cm1: enclosure level(0x0001), connector name(     )
[650032.283731] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x500304800000007f)
[650032.292960] mpt3sas_cm1: expander_remove: handle(0x0012),
sas_addr(0x500304800000007f), port:255
[650032.312166] sd 9:0:9:0: [sdj] Synchronizing SCSI cache
[650032.321452] sd 9:0:9:0: [sdj] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650032.340054] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e126)
[650032.349407] mpt3sas_cm1: removing handle(0x0013),
sas_addr(0x5003048029c4e126)
[650032.358745] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(22)
[650032.368133] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650032.398122] sd 9:0:10:0: [sdk] Synchronizing SCSI cache
[650032.407464] sd 9:0:10:0: [sdk] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[650032.426194] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e127)
[650032.435541] mpt3sas_cm1: removing handle(0x0014),
sas_addr(0x5003048029c4e127)
[650032.444877] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(23)
[650032.454262] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650032.464248] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e13d)
[650032.473703] mpt3sas_cm1: removing handle(0x0015),
sas_addr(0x5003048029c4e13d)
[650032.483010] mpt3sas_cm1: enclosure logical id(0x5003048029c4e13f), slot=
(24)
[650032.492179] mpt3sas_cm1: enclosure level(0x0000), connector name(     )
[650032.504030] mpt3sas_cm1: mpt3sas_transport_port_remove: removed:
sas_addr(0x5003048029c4e13f)
[650032.513228] mpt3sas_cm1: expander_remove: handle(0x0009),
sas_addr(0x5003048029c4e13f), port:255
[650035.566968] XFS (dm-11): log I/O error -5
[650035.567059] XFS (dm-11): metadata I/O error in "xfs_buf_ioend+0x277/0x5=
30
[xfs]" at daddr 0x118000001 len 1 error 5
[650035.576218] XFS (dm-11): Log I/O Error (0x2) detected at
xlog_ioend_work+0x71/0x80 [xfs] (fs/xfs/xfs_log.c:1377).  Shutting down
filesystem.
[650035.613638] XFS (dm-11): Please unmount the filesystem and rectify the
problem(s)
[650041.768640] mpt3sas_cm1: SMP command sent to the expander (handle:0x000=
9,
sas_address:0x5003048029c4e13f, physical_port:0x00) has failed
[650048.680811] mpt3sas_cm1: expander_add: handle(0x0009), parent(0x0001),
sas_addr(0x5003048029c4e13f), phys(51)
[650048.719744]  expander-9:2: add: handle(0x0009),
sas_addr(0x5003048029c4e13f)
[650050.011142] mpt3sas_cm1: log_info(0x311c0100): originator(PL), code(0x1=
c),
sub_code(0x0100)
[650050.030383] mpt3sas_cm1: handle(0xa) sas_address(0x5003048029c4e100)
port_type(0x1)
[650052.010720] mpt3sas_cm1: log_info(0x31110e05): originator(PL), code(0x1=
1),
sub_code(0x0e05)
[650052.510729] scsi 9:0:19:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650052.520942] scsi 9:0:19:0: SATA: handle(0x000a),
sas_addr(0x5003048029c4e100), phy(0), device_name(0x0000000000000000)
[650052.541109] scsi 9:0:19:0: enclosure logical id (0x5003048029c4e13f),
slot(0)
[650052.551336] scsi 9:0:19:0: enclosure level(0x0000), connector name(    =
 )
[650052.561438] scsi 9:0:19:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650052.571456] scsi 9:0:19:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650052.584096] sd 9:0:19:0: Attached scsi generic sg1 type 0
[650052.584189] sd 9:0:19:0: Power-on or device reset occurred
[650052.594025]  end_device-9:2:0: add: handle(0x000a),
sas_addr(0x5003048029c4e100)
[650052.604955] sd 9:0:19:0: [sdl] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650052.614001] mpt3sas_cm1: handle(0xb) sas_address(0x5003048029c4e101)
port_type(0x1)
[650052.625170] sd 9:0:19:0: [sdl] Write Protect is off
[650052.643826] sd 9:0:19:0: [sdl] Mode Sense: 9b 00 10 08
[650052.644228] sd 9:0:19:0: [sdl] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650052.680246]  sdl: sdl1
[650052.705183] sd 9:0:19:0: [sdl] Attached SCSI disk
[650053.010701] scsi 9:0:20:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650053.020674] scsi 9:0:20:0: SATA: handle(0x000b),
sas_addr(0x5003048029c4e101), phy(1), device_name(0x0000000000000000)
[650053.040443] scsi 9:0:20:0: enclosure logical id (0x5003048029c4e13f),
slot(1)
[650053.050584] scsi 9:0:20:0: enclosure level(0x0000), connector name(    =
 )
[650053.060659] scsi 9:0:20:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650053.070726] scsi 9:0:20:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650053.083367] sd 9:0:20:0: Attached scsi generic sg2 type 0
[650053.083457] sd 9:0:20:0: Power-on or device reset occurred
[650053.093256]  end_device-9:2:1: add: handle(0x000b),
sas_addr(0x5003048029c4e101)
[650053.104065] sd 9:0:20:0: [sdm] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650053.112643] mpt3sas_cm1: handle(0xc) sas_address(0x5003048029c4e102)
port_type(0x1)
[650053.123355] sd 9:0:20:0: [sdm] Write Protect is off
[650053.141146] sd 9:0:20:0: [sdm] Mode Sense: 9b 00 10 08
[650053.141553] sd 9:0:20:0: [sdm] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650053.185412]  sdm: sdm1
[650053.210169] sd 9:0:20:0: [sdm] Attached SCSI disk
[650053.510623] scsi 9:0:21:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650053.519775] scsi 9:0:21:0: SATA: handle(0x000c),
sas_addr(0x5003048029c4e102), phy(2), device_name(0x0000000000000000)
[650053.537771] scsi 9:0:21:0: enclosure logical id (0x5003048029c4e13f),
slot(2)
[650053.546912] scsi 9:0:21:0: enclosure level(0x0000), connector name(    =
 )
[650053.555955] scsi 9:0:21:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650053.565006] scsi 9:0:21:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650053.576632] sd 9:0:21:0: Attached scsi generic sg3 type 0
[650053.576722] sd 9:0:21:0: Power-on or device reset occurred
[650053.585465]  end_device-9:2:2: add: handle(0x000c),
sas_addr(0x5003048029c4e102)
[650053.595274] sd 9:0:21:0: [sdn] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650053.603166] mpt3sas_cm1: handle(0xe) sas_address(0x5003048029c4e104)
port_type(0x1)
[650053.613152] sd 9:0:21:0: [sdn] Write Protect is off
[650053.629877] sd 9:0:21:0: [sdn] Mode Sense: 9b 00 10 08
[650053.630274] sd 9:0:21:0: [sdn] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650053.669191]  sdn: sdn1
[650053.690103] sd 9:0:21:0: [sdn] Attached SCSI disk
[650054.010595] scsi 9:0:22:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650054.019536] scsi 9:0:22:0: SATA: handle(0x000e),
sas_addr(0x5003048029c4e104), phy(4), device_name(0x0000000000000000)
[650054.037260] scsi 9:0:22:0: enclosure logical id (0x5003048029c4e13f),
slot(4)
[650054.046347] scsi 9:0:22:0: enclosure level(0x0000), connector name(    =
 )
[650054.055386] scsi 9:0:22:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650054.064430] scsi 9:0:22:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650054.076054] sd 9:0:22:0: Attached scsi generic sg4 type 0
[650054.076145] sd 9:0:22:0: Power-on or device reset occurred
[650054.084889]  end_device-9:2:3: add: handle(0x000e),
sas_addr(0x5003048029c4e104)
[650054.094815] sd 9:0:22:0: [sdo] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650054.102590] mpt3sas_cm1: handle(0xf) sas_address(0x5003048029c4e105)
port_type(0x1)
[650054.112579] sd 9:0:22:0: [sdo] Write Protect is off
[650054.129266] sd 9:0:22:0: [sdo] Mode Sense: 9b 00 10 08
[650054.129672] sd 9:0:22:0: [sdo] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650054.178343]  sdo: sdo1
[650054.199123] sd 9:0:22:0: [sdo] Attached SCSI disk
[650054.510631] scsi 9:0:23:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650054.519557] scsi 9:0:23:0: SATA: handle(0x000f),
sas_addr(0x5003048029c4e105), phy(5), device_name(0x0000000000000000)
[650054.537273] scsi 9:0:23:0: enclosure logical id (0x5003048029c4e13f),
slot(5)
[650054.546364] scsi 9:0:23:0: enclosure level(0x0000), connector name(    =
 )
[650054.555417] scsi 9:0:23:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650054.564474] scsi 9:0:23:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650054.576100] sd 9:0:23:0: Attached scsi generic sg5 type 0
[650054.576185] sd 9:0:23:0: Power-on or device reset occurred
[650054.584935]  end_device-9:2:4: add: handle(0x000f),
sas_addr(0x5003048029c4e105)
[650054.594762] sd 9:0:23:0: [sdp] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650054.602636] mpt3sas_cm1: handle(0x10) sas_address(0x5003048029c4e106)
port_type(0x1)
[650054.612632] sd 9:0:23:0: [sdp] Write Protect is off
[650054.629314] sd 9:0:23:0: [sdp] Mode Sense: 9b 00 10 08
[650054.629721] sd 9:0:23:0: [sdp] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650054.660314]  sdp: sdp1
[650054.685082] sd 9:0:23:0: [sdp] Attached SCSI disk
[650055.010572] scsi 9:0:24:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650055.019511] scsi 9:0:24:0: SATA: handle(0x0010),
sas_addr(0x5003048029c4e106), phy(6), device_name(0x0000000000000000)
[650055.037235] scsi 9:0:24:0: enclosure logical id (0x5003048029c4e13f),
slot(6)
[650055.046337] scsi 9:0:24:0: enclosure level(0x0000), connector name(    =
 )
[650055.055385] scsi 9:0:24:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650055.064437] scsi 9:0:24:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650055.076189] sd 9:0:24:0: Attached scsi generic sg6 type 0
[650055.076272] sd 9:0:24:0: Power-on or device reset occurred
[650055.085040]  end_device-9:2:5: add: handle(0x0010),
sas_addr(0x5003048029c4e106)
[650055.094865] sd 9:0:24:0: [sdq] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650055.102756] mpt3sas_cm1: handle(0x11) sas_address(0x5003048029c4e107)
port_type(0x1)
[650055.112748] sd 9:0:24:0: [sdq] Write Protect is off
[650055.129449] sd 9:0:24:0: [sdq] Mode Sense: 9b 00 10 08
[650055.129850] sd 9:0:24:0: [sdq] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650055.165237]  sdq: sdq1
[650055.192064] sd 9:0:24:0: [sdq] Attached SCSI disk
[650055.510587] scsi 9:0:25:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650055.519537] scsi 9:0:25:0: SATA: handle(0x0011),
sas_addr(0x5003048029c4e107), phy(7), device_name(0x0000000000000000)
[650055.537288] scsi 9:0:25:0: enclosure logical id (0x5003048029c4e13f),
slot(7)
[650055.546411] scsi 9:0:25:0: enclosure level(0x0000), connector name(    =
 )
[650055.555468] scsi 9:0:25:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650055.564539] scsi 9:0:25:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650055.576161] sd 9:0:25:0: Attached scsi generic sg7 type 0
[650055.576244] sd 9:0:25:0: Power-on or device reset occurred
[650055.585008]  end_device-9:2:6: add: handle(0x0011),
sas_addr(0x5003048029c4e107)
[650055.594838] sd 9:0:25:0: [sdr] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650055.603857] mpt3sas_cm1: handle(0x13) sas_address(0x5003048029c4e126)
port_type(0x1)
[650055.612753] sd 9:0:25:0: [sdr] Write Protect is off
[650055.629500] sd 9:0:25:0: [sdr] Mode Sense: 9b 00 10 08
[650055.629921] sd 9:0:25:0: [sdr] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650055.661112]  sdr: sdr1
[650055.687988] sd 9:0:25:0: [sdr] Attached SCSI disk
[650056.009299] scsi 9:0:26:0: Direct-Access     ATA      Samsung SSD 850  =
2B6Q
PQ: 0 ANSI: 6
[650056.018267] scsi 9:0:26:0: SATA: handle(0x0013),
sas_addr(0x5003048029c4e126), phy(38), device_name(0x0000000000000000)
[650056.036047] scsi 9:0:26:0: enclosure logical id (0x5003048029c4e13f),
slot(22)
[650056.045172] scsi 9:0:26:0: enclosure level(0x0000), connector name(    =
 )
[650056.054247] scsi 9:0:26:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650056.063334] scsi 9:0:26:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650056.073744] sd 9:0:26:0: Attached scsi generic sg8 type 0
[650056.073828] sd 9:0:26:0: Power-on or device reset occurred
[650056.082606]  end_device-9:2:7: add: handle(0x0013),
sas_addr(0x5003048029c4e126)
[650056.092618] sd 9:0:26:0: [sds] 7814037168 512-byte logical blocks: (4.00
TB/3.64 TiB)
[650056.100369] mpt3sas_cm1: handle(0x14) sas_address(0x5003048029c4e127)
port_type(0x1)
[650056.111935] sd 9:0:26:0: [sds] Write Protect is off
[650056.127132] sd 9:0:26:0: [sds] Mode Sense: 9b 00 10 08
[650056.127587] sd 9:0:26:0: [sds] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650056.167285]  sds: sds1
[650056.195019] sd 9:0:26:0: [sds] Attached SCSI disk
[650056.509159] scsi 9:0:27:0: Direct-Access     ATA      Samsung SSD 850  =
2B6Q
PQ: 0 ANSI: 6
[650056.518133] scsi 9:0:27:0: SATA: handle(0x0014),
sas_addr(0x5003048029c4e127), phy(39), device_name(0x0000000000000000)
[650056.535936] scsi 9:0:27:0: enclosure logical id (0x5003048029c4e13f),
slot(23)
[650056.545096] scsi 9:0:27:0: enclosure level(0x0000), connector name(    =
 )
[650056.554188] scsi 9:0:27:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650056.563291] scsi 9:0:27:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650056.573599] sd 9:0:27:0: Attached scsi generic sg9 type 0
[650056.573702] sd 9:0:27:0: Power-on or device reset occurred
[650056.582474]  end_device-9:2:8: add: handle(0x0014),
sas_addr(0x5003048029c4e127)
[650056.592557] sd 9:0:27:0: [sdt] 7814037168 512-byte logical blocks: (4.00
TB/3.64 TiB)
[650056.600238] mpt3sas_cm1: handle(0x15) sas_address(0x5003048029c4e13d)
port_type(0x1)
[650056.611996] sd 9:0:27:0: [sdt] Write Protect is off
[650056.619586] scsi 9:0:28:0: Enclosure         SMC      SC216-P          =
100d
PQ: 0 ANSI: 5
[650056.627034] sd 9:0:27:0: [sdt] Mode Sense: 9b 00 10 08
[650056.636125] scsi 9:0:28:0: set ignore_delay_remove for handle(0x0015)
[650056.636612] sd 9:0:27:0: [sdt] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650056.645114] scsi 9:0:28:0: SES: handle(0x0015),
sas_addr(0x5003048029c4e13d), phy(40), device_name(0x5003048029c4e13c)
[650056.645116] scsi 9:0:28:0: enclosure logical id (0x5003048029c4e13f),
slot(24)
[650056.681500] scsi 9:0:28:0: enclosure level(0x0000), connector name(    =
 )
[650056.690702] scsi 9:0:28:0: qdepth(254), tagged(1), scsi_level(6),
cmd_que(1)
[650056.699904] scsi 9:0:28:0: Power-on or device reset occurred
[650056.709606] ses 9:0:28:0: Attached Enclosure device
[650056.718493] ses 9:0:28:0: Attached scsi generic sg10 type 13
[650056.728904]  end_device-9:2:9: add: handle(0x0015),
sas_addr(0x5003048029c4e13d)
[650056.741662] mpt3sas_cm1: handle(0xd) sas_address(0x5003048029c4e103)
port_type(0x1)
[650056.746611]  sdt: sdt1
[650056.784161] sd 9:0:27:0: [sdt] Attached SCSI disk
[650057.010572] scsi 9:0:29:0: Direct-Access     ATA      Samsung SSD 850  =
3B6Q
PQ: 0 ANSI: 6
[650057.019555] scsi 9:0:29:0: SATA: handle(0x000d),
sas_addr(0x5003048029c4e103), phy(3), device_name(0x0000000000000000)
[650057.037291] scsi 9:0:29:0: enclosure logical id (0x5003048029c4e13f),
slot(3)
[650057.046269] scsi 9:0:29:0: enclosure level(0x0000), connector name(    =
 )
[650057.055187] scsi 9:0:29:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650057.064159] scsi 9:0:29:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650057.075754] sd 9:0:29:0: Attached scsi generic sg11 type 0
[650057.075865] sd 9:0:29:0: Power-on or device reset occurred
[650057.085121]  end_device-9:2:10: add: handle(0x000d),
sas_addr(0x5003048029c4e103)
[650057.094510] sd 9:0:29:0: [sdu] 1953525168 512-byte logical blocks: (1.00
TB/932 GiB)
[650057.104554] mpt3sas_cm1: expander_add: handle(0x0012), parent(0x0009),
sas_addr(0x500304800000007f), phys(30)
[650057.112318] sd 9:0:29:0: [sdu] Write Protect is off
[650057.129296]  expander-9:3: add: handle(0x0012),
sas_addr(0x500304800000007f)
[650057.137610] sd 9:0:29:0: [sdu] Mode Sense: 9b 00 10 08
[650057.137998] sd 9:0:29:0: [sdu] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650057.154959] mpt3sas_cm1: handle(0x16) sas_address(0x500304800000006e)
port_type(0x1)
[650057.189975]  sdu: sdu1
[650057.213914] sd 9:0:29:0: [sdu] Attached SCSI disk
[650057.509399] scsi 9:0:30:0: Direct-Access     ATA      ST2000DM001-1ER1 =
CC26
PQ: 0 ANSI: 6
[650057.518501] scsi 9:0:30:0: SATA: handle(0x0016),
sas_addr(0x500304800000006e), phy(14), device_name(0x0000000000000000)
[650057.536520] scsi 9:0:30:0: enclosure logical id (0x500304800000007f),
slot(2)
[650057.545717] scsi 9:0:30:0: enclosure level(0x0001), connector name(    =
 )
[650057.554836] scsi 9:0:30:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650057.563905] scsi 9:0:30:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650057.574879] sd 9:0:30:0: Attached scsi generic sg12 type 0
[650057.574986] sd 9:0:30:0: Power-on or device reset occurred
[650057.584216]  end_device-9:3:0: add: handle(0x0016),
sas_addr(0x500304800000006e)
[650057.594460] sd 9:0:30:0: [sdv] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[650057.601474] mpt3sas_cm1: handle(0x17) sas_address(0x500304800000006f)
port_type(0x1)
[650057.610369] sd 9:0:30:0: [sdv] 4096-byte physical blocks
[650057.899866] sd 9:0:30:0: [sdv] Write Protect is off
[650057.908886] sd 9:0:30:0: [sdv] Mode Sense: 9b 00 10 08
[650057.909789] sd 9:0:30:0: [sdv] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650058.009445] scsi 9:0:31:0: Direct-Access     ATA      ST2000DM001-1ER1 =
CC26
PQ: 0 ANSI: 6
[650058.018580] scsi 9:0:31:0: SATA: handle(0x0017),
sas_addr(0x500304800000006f), phy(15), device_name(0x0000000000000000)
[650058.036890] scsi 9:0:31:0: enclosure logical id (0x500304800000007f),
slot(3)
[650058.039205]  sdv: sdv1
[650058.046172] scsi 9:0:31:0: enclosure level(0x0001), connector name(    =
 )
[650058.046225] scsi 9:0:31:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650058.073529] scsi 9:0:31:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650058.084850] sd 9:0:31:0: Attached scsi generic sg13 type 0
[650058.084971] sd 9:0:31:0: Power-on or device reset occurred
[650058.094493]  end_device-9:3:1: add: handle(0x0017),
sas_addr(0x500304800000006f)
[650058.105005] sd 9:0:31:0: [sdw] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[650058.112346] mpt3sas_cm1: handle(0x18) sas_address(0x5003048000000071)
port_type(0x1)
[650058.121488] sd 9:0:31:0: [sdw] 4096-byte physical blocks
[650058.244054] sd 9:0:30:0: [sdv] Attached SCSI disk
[650058.403711] sd 9:0:31:0: [sdw] Write Protect is off
[650058.412544] sd 9:0:31:0: [sdw] Mode Sense: 9b 00 10 08
[650058.413432] sd 9:0:31:0: [sdw] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650058.509342] scsi 9:0:32:0: Direct-Access     ATA      ST2000DM001-1CH1 =
CC29
PQ: 0 ANSI: 6
[650058.518269] scsi 9:0:32:0: SATA: handle(0x0018),
sas_addr(0x5003048000000071), phy(17), device_name(0x0000000000000000)
[650058.535838] scsi 9:0:32:0: enclosure logical id (0x500304800000007f),
slot(5)
[650058.544860] scsi 9:0:32:0: enclosure level(0x0001), connector name(    =
 )
[650058.553839] scsi 9:0:32:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650058.562831] scsi 9:0:32:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650058.573645] sd 9:0:32:0: Attached scsi generic sg14 type 0
[650058.573737] sd 9:0:32:0: Power-on or device reset occurred
[650058.578374]  sdw: sdw1
[650058.582810]  end_device-9:3:2: add: handle(0x0018),
sas_addr(0x5003048000000071)
[650058.592946] sd 9:0:32:0: [sdx] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[650058.599643] mpt3sas_cm1: handle(0x19) sas_address(0x5003048000000072)
port_type(0x1)
[650058.608222] sd 9:0:32:0: [sdx] 4096-byte physical blocks
[650058.722890] sd 9:0:31:0: [sdw] Attached SCSI disk
[650058.878477] sd 9:0:32:0: [sdx] Write Protect is off
[650058.886977] sd 9:0:32:0: [sdx] Mode Sense: 9b 00 10 08
[650058.887800] sd 9:0:32:0: [sdx] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650059.009279] scsi 9:0:33:0: Direct-Access     ATA      ST2000DM001-1CH1 =
CC29
PQ: 0 ANSI: 6
[650059.018039] scsi 9:0:33:0: SATA: handle(0x0019),
sas_addr(0x5003048000000072), phy(18), device_name(0x0000000000000000)
[650059.031759]  sdx: sdx1
[650059.035405] scsi 9:0:33:0: enclosure logical id (0x500304800000007f),
slot(6)
[650059.035406] scsi 9:0:33:0: enclosure level(0x0001), connector name(    =
 )
[650059.035455] scsi 9:0:33:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650059.069170] scsi 9:0:33:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650059.079538] sd 9:0:33:0: Attached scsi generic sg15 type 0
[650059.079636] sd 9:0:33:0: Power-on or device reset occurred
[650059.088335]  end_device-9:3:3: add: handle(0x0019),
sas_addr(0x5003048000000072)
[650059.098009] sd 9:0:33:0: [sdy] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[650059.104577] mpt3sas_cm1: handle(0x1a) sas_address(0x5003048000000073)
port_type(0x1)
[650059.112940] sd 9:0:33:0: [sdy] 4096-byte physical blocks
[650059.196921] sd 9:0:32:0: [sdx] Attached SCSI disk
[650059.390835] sd 9:0:33:0: [sdy] Write Protect is off
[650059.398933] sd 9:0:33:0: [sdy] Mode Sense: 9b 00 10 08
[650059.399748] sd 9:0:33:0: [sdy] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650059.509364] scsi 9:0:34:0: Direct-Access     ATA      WDC WD20EZRZ-00Z =
0A80
PQ: 0 ANSI: 6
[650059.517855] scsi 9:0:34:0: SATA: handle(0x001a),
sas_addr(0x5003048000000073), phy(19), device_name(0x0000000000000000)
[650059.534688] scsi 9:0:34:0: enclosure logical id (0x500304800000007f),
slot(7)
[650059.543231] scsi 9:0:34:0: enclosure level(0x0001), connector name(    =
 )
[650059.546299]  sdy: sdy1
[650059.551658] scsi 9:0:34:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650059.568168] scsi 9:0:34:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650059.578860] sd 9:0:34:0: Attached scsi generic sg16 type 0
[650059.578967] sd 9:0:34:0: Power-on or device reset occurred
[650059.587682]  end_device-9:3:4: add: handle(0x001a),
sas_addr(0x5003048000000073)
[650059.597481] sd 9:0:34:0: [sdz] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[650059.604328] mpt3sas_cm1: handle(0x1b) sas_address(0x5003048000000076)
port_type(0x1)
[650059.612471] sd 9:0:34:0: [sdz] 4096-byte physical blocks
[650059.632563] sd 9:0:34:0: [sdz] Write Protect is off
[650059.640874] sd 9:0:34:0: [sdz] Mode Sense: 9b 00 10 08
[650059.641687] sd 9:0:34:0: [sdz] Write cache: enabled, read cache: enable=
d,
supports DPO and FUA
[650059.709600] sd 9:0:33:0: [sdy] Attached SCSI disk
[650060.009314] scsi 9:0:35:0: Direct-Access     ATA      ST3000DM001-1CH1 =
CC27
PQ: 0 ANSI: 6
[650060.017980] scsi 9:0:35:0: SATA: handle(0x001b),
sas_addr(0x5003048000000076), phy(22), device_name(0x0000000000000000)
[650060.035156] scsi 9:0:35:0: enclosure logical id (0x500304800000007f),
slot(10)
[650060.043856] scsi 9:0:35:0: enclosure level(0x0001), connector name(    =
 )
[650060.052414] scsi 9:0:35:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650060.061139] scsi 9:0:35:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650060.071861] sd 9:0:35:0: Attached scsi generic sg17 type 0
[650060.071954] sd 9:0:35:0: Power-on or device reset occurred
[650060.081016]  end_device-9:3:5: add: handle(0x001b),
sas_addr(0x5003048000000076)
[650060.091111] sd 9:0:35:0: [sdaa] 5860533168 512-byte logical blocks: (3.=
00
TB/2.73 TiB)
[650060.097940] mpt3sas_cm1: handle(0x1c) sas_address(0x5003048000000077)
port_type(0x1)
[650060.106555] sd 9:0:35:0: [sdaa] 4096-byte physical blocks
[650060.293060]  sdz: sdz1
[650060.322523] sd 9:0:34:0: [sdz] Attached SCSI disk
[650060.391876] sd 9:0:35:0: [sdaa] Write Protect is off
[650060.400283] sd 9:0:35:0: [sdaa] Mode Sense: 9b 00 10 08
[650060.401153] sd 9:0:35:0: [sdaa] Write cache: enabled, read cache: enabl=
ed,
supports DPO and FUA
[650060.509262] scsi 9:0:36:0: Direct-Access     ATA      ST3000DM001-1CH1 =
CC27
PQ: 0 ANSI: 6
[650060.518100] scsi 9:0:36:0: SATA: handle(0x001c),
sas_addr(0x5003048000000077), phy(23), device_name(0x0000000000000000)
[650060.535617] scsi 9:0:36:0: enclosure logical id (0x500304800000007f),
slot(11)
[650060.544499] scsi 9:0:36:0: enclosure level(0x0001), connector name(    =
 )
[650060.550725]  sdaa: sdaa1
[650060.553252] scsi 9:0:36:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[650060.570493] scsi 9:0:36:0: qdepth(32), tagged(1), scsi_level(7), cmd_qu=
e(1)
[650060.581391] sd 9:0:36:0: Attached scsi generic sg18 type 0
[650060.581506] sd 9:0:36:0: Power-on or device reset occurred
[650060.590548]  end_device-9:3:6: add: handle(0x001c),
sas_addr(0x5003048000000077)
[650060.600605] sd 9:0:36:0: [sdab] 5860533168 512-byte logical blocks: (3.=
00
TB/2.73 TiB)
[650060.607436] mpt3sas_cm1: handle(0x1d) sas_address(0x500304800000007d)
port_type(0x1)
[650060.616132] sd 9:0:36:0: [sdab] 4096-byte physical blocks
[650060.626773] scsi 9:0:37:0: Enclosure         LSI      SAS2X28          =
0e12
PQ: 0 ANSI: 5
[650060.642560] scsi 9:0:37:0: set ignore_delay_remove for handle(0x001d)
[650060.651277] scsi 9:0:37:0: SES: handle(0x001d),
sas_addr(0x500304800000007d), phy(28), device_name(0x0000000000000000)
[650060.669048] scsi 9:0:37:0: enclosure logical id (0x500304800000007f),
slot(0)
[650060.678111] scsi 9:0:37:0: enclosure level(0x0001), connector name(    =
 )
[650060.687075] scsi 9:0:37:0: qdepth(254), tagged(1), scsi_level(6),
cmd_que(1)
[650060.697858] ses 9:0:37:0: Attached Enclosure device
[650060.706641] ses 9:0:37:0: Attached scsi generic sg19 type 13
[650060.710682] sd 9:0:35:0: [sdaa] Attached SCSI disk
[650060.718912]  end_device-9:3:7: add: handle(0x001d),
sas_addr(0x500304800000007d)
[650060.733649] mpt3sas_cm1: _scsih_sas_broadcast_primitive_event: enter: p=
hy
number(2), width(8)
[650060.742419] sd 9:0:19:0: device_block, handle(0x000a)
[650060.751106] sd 9:0:20:0: device_block, handle(0x000b)
[650060.759712] sd 9:0:21:0: device_block, handle(0x000c)
[650060.768098] sd 9:0:22:0: device_block, handle(0x000e)
[650060.776228] sd 9:0:23:0: device_block, handle(0x000f)
[650060.784130] sd 9:0:24:0: device_block, handle(0x0010)
[650060.791799] sd 9:0:25:0: device_block, handle(0x0011)
[650060.799328] sd 9:0:26:0: device_block, handle(0x0013)
[650060.806746] sd 9:0:27:0: device_block, handle(0x0014)
[650060.814099] ses 9:0:28:0: _scsih_block_io_all_device skip device_block =
for
SES handle(0x0015)
[650060.821678] sd 9:0:29:0: device_block, handle(0x000d)
[650060.829102] sd 9:0:30:0: device_block, handle(0x0016)
[650060.836315] sd 9:0:31:0: device_block, handle(0x0017)
[650060.843229] sd 9:0:32:0: device_block, handle(0x0018)
[650060.849906] sd 9:0:33:0: device_block, handle(0x0019)
[650060.856447] sd 9:0:34:0: device_block, handle(0x001a)
[650060.862812] sd 9:0:35:0: device_block, handle(0x001b)
[650060.868922] sd 9:0:36:0: device_block, handle(0x001c)
[650060.874815] ses 9:0:37:0: _scsih_block_io_all_device skip device_block =
for
SES handle(0x001d)
[650060.882092] sd 9:0:19:0: device_unblock and setting to running,
handle(0x000a)
[650060.888304] sd 9:0:20:0: device_unblock and setting to running,
handle(0x000b)
[650060.894298] sd 9:0:21:0: device_unblock and setting to running,
handle(0x000c)
[650060.900049] sd 9:0:22:0: device_unblock and setting to running,
handle(0x000e)
[650060.905574] sd 9:0:23:0: device_unblock and setting to running,
handle(0x000f)
[650060.909566] sd 9:0:36:0: [sdab] Write Protect is off
[650060.910852] sd 9:0:24:0: device_unblock and setting to running,
handle(0x0010)
[650060.916010] sd 9:0:36:0: [sdab] Mode Sense: 9b 00 10 08
[650060.921247] sd 9:0:25:0: device_unblock and setting to running,
handle(0x0011)
[650060.921249] sd 9:0:26:0: device_unblock and setting to running,
handle(0x0013)
[650060.930948] sd 9:0:27:0: device_unblock and setting to running,
handle(0x0014)
[650060.935403] sd 9:0:29:0: device_unblock and setting to running,
handle(0x000d)
[650060.939730] sd 9:0:30:0: device_unblock and setting to running,
handle(0x0016)
[650060.943914] sd 9:0:31:0: device_unblock and setting to running,
handle(0x0017)
[650060.947890] sd 9:0:32:0: device_unblock and setting to running,
handle(0x0018)
[650060.951782] sd 9:0:33:0: device_unblock and setting to running,
handle(0x0019)
[650060.955531] sd 9:0:34:0: device_unblock and setting to running,
handle(0x001a)
[650060.959065] sd 9:0:35:0: device_unblock and setting to running,
handle(0x001b)
[650060.962331] sd 9:0:36:0: device_unblock and setting to running,
handle(0x001c)
[650060.984491] sd 9:0:36:0: [sdab] Write cache: enabled, read cache: enabl=
ed,
supports DPO and FUA
[650061.138883]  sdab: sdab1
[650061.228344] sd 9:0:36:0: [sdab] Attached SCSI disk
[root@vm2 ~]#

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
