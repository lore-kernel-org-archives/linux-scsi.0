Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EE2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 02:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357160AbiD0CXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357152AbiD0CXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 22:23:11 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DFA2675
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 19:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651026001; x=1682562001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5TeQN5lhR4Ahp6383VgZCh7eErXQ5BHljxeq6DTkar0=;
  b=iGfL2ovJxRdTO4Wa38JfYEcX3CL6CKOKR4ZvdLjXJN4qiNxZSNDokwNO
   KMceCQa3s6MfGClVpJGGkrr6lAzra4yg+UqzcHB8ZANKSXS+vgvyMFz86
   zSnny8gw/TLwDJThcPXW4Mxr6/YKyBKBdw4KKabKULMs4l8rlmBZSvveV
   QfmKTiuuCCzeLm3vZYZ5Pujw65mGFB6EtlgYs3IdSYCdXFhog9eNAxiUY
   Og8hhl20O0XpGwFappOy4ZXObiTW043Tylu7uH85/+pt1LomXdIi/EniJ
   weEdCtFHz5XOx1KiIVQQrPSkVTBc0aE9Wl1xoqDWBfzzBfM+tdI4cz8sU
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; 
   d="scan'208";a="303120020"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 10:19:58 +0800
IronPort-SDR: dR3qvnkahCmcu7xkYWoRXTMnSI03WjjYxtN0DCEegv2j2Z4tIBXyON88nu46+pifec27fSLf2j
 zXb49shCeqei+xMdnvMjx8Ydcjm4BT+Qg0JrTShtQpAJCo/bux+eAQoQOR7QoPR11RR9t7or8W
 d2tvr1EnJzWqa9jff+FQNUAV6WaEn/+jqhmiLagI+6F0OiGt3gXMsIKSPCeffSzgWnN5Qkp5V8
 abSmH/8NRqu6/RH0cvUQobsSCPxhu24FgKm8VuYFZ5eUkN8UoPqM/gVq9kQ5cWnHiF1DmBIF23
 GcZJmpLTpDx9fG4TCKJjjT3K
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 18:50:09 -0700
IronPort-SDR: /64e2l98vuLw51ykOL20kEJQyYuM7VxLg0WwNOHe5sWvUjIJUNNta2s4CNCA7qylwjior9K5Nq
 9eCTasys3EZmuJDe6/VLQCWtA0AY79JA40f4l3y7QNyO4c1LnztVJMOwA5Ph0ZDYaAW2dUop2k
 g1cFDH9/S3I3L3Puo1tg19E7ue6ubbarW1K9MonCnlec0rn12EA7yPYXAUQbP6uyXN96sD5hv1
 3Kvx/vNauniKsL2dvX4znMfcx7OxwbBXUjq8RvXUyiAdxgwn94VXVEODoJsz8BJzZpMdX0kJ6R
 SB4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 19:19:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp2Wy3JbYz1SVp1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 19:19:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651025996; x=1653617997; bh=5TeQN5lhR4Ahp6383VgZCh7eErXQ5BHljxe
        q6DTkar0=; b=HLh3gOdIoLSGUUyUMi7ugQ80WGd64u85fuvUH7mJ8KLbrYvw+n4
        ZfEA4vmz1fIqGmNkLDTQnp/EARZTn46QbXeSk9AgyEeRoc7QmzuDr9+HSFQaGPS8
        f1KVXkLxmHZEAFQGUY6AEqMMZEzD6CBczxJOM0lOCUAGFZdIHa4uWWiTNs+eHmga
        PvLhDA+WtojKoy1rBnwEqxVn9ie+kA361GS9CQqkEl2D2izLQHDP6fZUcMAJX4bG
        PN52+3YAVZz25etiQ45f0l/NwYQB1q3ZmAaDgflCx0DlZ/VOoK33B2u08wb5A2no
        P8lJfWB4SE71FKiYeaqRUK95YDBBPOWivdg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id crIwcbkS8549 for <linux-scsi@vger.kernel.org>;
        Tue, 26 Apr 2022 19:19:56 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp2Wn4QZqz1Rvlc;
        Tue, 26 Apr 2022 19:19:49 -0700 (PDT)
Message-ID: <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
Date:   Wed, 27 Apr 2022 11:19:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 00/10] Add Copy offload support
Content-Language: en-US
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     chaitanyak@nvidia.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, hare@suse.de, kbusch@kernel.org,
        hch@lst.de, Frederick.Knight@netapp.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, nitheshshetty@gmail.com, gost.dev@samsung.com,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <james.smart@broadcom.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220426101241.30100-1-nj.shetty@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/22 19:12, Nitesh Shetty wrote:
> The patch series covers the points discussed in November 2021 virtual c=
all
> [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
> We have covered the Initial agreed requirements in this patchset.
> Patchset borrows Mikulas's token based approach for 2 bdev
> implementation.
>=20
> Overall series supports =E2=80=93
>=20
> 1. Driver
> - NVMe Copy command (single NS), including support in nvme-target (for
>     block and file backend)

It would also be nice to have copy offload emulation in null_blk for test=
ing.

>=20
> 2. Block layer
> - Block-generic copy (REQ_COPY flag), with interface accommodating
>     two block-devs, and multi-source/destination interface
> - Emulation, when offload is natively absent
> - dm-linear support (for cases not requiring split)
>=20
> 3. User-interface
> - new ioctl
> - copy_file_range for zonefs
>=20
> 4. In-kernel user
> - dm-kcopyd
> - copy_file_range in zonefs
>=20
> For zonefs copy_file_range - Seems we cannot levearge fstest here. Limi=
ted
> testing is done at this point using a custom application for unit testi=
ng.
>=20
> Appreciate the inputs on plumbing and how to test this further?
> Perhaps some of it can be discussed during LSF/MM too.
>=20
> [0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=3DzT1=
4mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
>=20
> Changes in v4:
> - added copy_file_range support for zonefs
> - added documentaion about new sysfs entries
> - incorporated review comments on v3
> - minor fixes
>=20
>=20
> Arnav Dawn (2):
>   nvmet: add copy command support for bdev and file ns
>   fs: add support for copy file range in zonefs
>=20
> Nitesh Shetty (7):
>   block: Introduce queue limits for copy-offload support
>   block: Add copy offload support infrastructure
>   block: Introduce a new ioctl for copy
>   block: add emulation for copy
>   nvme: add copy offload support
>   dm: Add support for copy offload.
>   dm: Enable copy offload for dm-linear target
>=20
> SelvaKumar S (1):
>   dm kcopyd: use copy offload support
>=20
>  Documentation/ABI/stable/sysfs-block |  83 +++++++
>  block/blk-lib.c                      | 358 +++++++++++++++++++++++++++
>  block/blk-map.c                      |   2 +-
>  block/blk-settings.c                 |  59 +++++
>  block/blk-sysfs.c                    | 138 +++++++++++
>  block/blk.h                          |   2 +
>  block/ioctl.c                        |  32 +++
>  drivers/md/dm-kcopyd.c               |  55 +++-
>  drivers/md/dm-linear.c               |   1 +
>  drivers/md/dm-table.c                |  45 ++++
>  drivers/md/dm.c                      |   6 +
>  drivers/nvme/host/core.c             | 116 ++++++++-
>  drivers/nvme/host/fc.c               |   4 +
>  drivers/nvme/host/nvme.h             |   7 +
>  drivers/nvme/host/pci.c              |  25 ++
>  drivers/nvme/host/rdma.c             |   6 +
>  drivers/nvme/host/tcp.c              |  14 ++
>  drivers/nvme/host/trace.c            |  19 ++
>  drivers/nvme/target/admin-cmd.c      |   8 +-
>  drivers/nvme/target/io-cmd-bdev.c    |  65 +++++
>  drivers/nvme/target/io-cmd-file.c    |  49 ++++
>  fs/zonefs/super.c                    | 178 ++++++++++++-
>  fs/zonefs/zonefs.h                   |   1 +
>  include/linux/blk_types.h            |  21 ++
>  include/linux/blkdev.h               |  17 ++
>  include/linux/device-mapper.h        |   5 +
>  include/linux/nvme.h                 |  43 +++-
>  include/uapi/linux/fs.h              |  23 ++
>  28 files changed, 1367 insertions(+), 15 deletions(-)
>=20
>=20
> base-commit: e7d6987e09a328d4a949701db40ef63fbb970670


--=20
Damien Le Moal
Western Digital Research
