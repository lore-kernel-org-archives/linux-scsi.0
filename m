Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E932C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 02:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357036AbiD0CEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356988AbiD0CES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 22:04:18 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5855511C30
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 19:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651024869; x=1682560869;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aVEYVQf35+Uh7XzM6a1kJevWBsv5Uf3EWaUSl6Zi8N0=;
  b=cZ0UP5E1jEANx21VqZOaoMOawPzIlE24Dr0Giaedj4NAB9LTKnJEEgZh
   d5jdNOEe4F4UqamYGw1u4+MhqKBo3lncDZ7OT/l4Hi+0nU0DUikrFc73H
   b1WG1VmVZU+8CMh5Dklo5i1GXCOpidOm05pYfd3dQ1tuH1SCVHyJxATmM
   YHNexuY/YP3pA392vZG4Spq1iZ1ov5l15FE9XQ1Ng5LNhzibK5LiKeU+0
   gBPs3IvKZGYYRHlEkvTQQz0o8LBAIOhzUS4qNx+nu5vPGk4ox9ms4mqYY
   q9R2J8YNf99k8XC4f4/sRxCnw1gmpeDlFGysRdB3wjBB3MBiu3P8kVYvs
   g==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; 
   d="scan'208";a="197753713"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 10:01:06 +0800
IronPort-SDR: O6NtG9CItsB2vodkzCF2m/GK/5aJnrnsF0bVObC7kaovN1UPMzh3rwMeAnNxYHVRE1fgH4qAZN
 HotTNSN5mAQKnHrnS15wnjtVbZkh8canopJ2wXvO3HpS4U/RyLnWPMGnAvGdiW2l2j6/AnqbsH
 rmjitPSIIU/IPeG4AxPoRSpJoxdXL39aVfQjd0K7utjY8SQ0m/b6rrlJNfG+xNJetWiYIlmZJs
 uNqibWVlmWb4cI4saNoBP8/2b+I62KcmdZwTUkmChfGyNpkh8YDNz3v7EKKk+5Beo9XtUkJ53/
 v6fTipiRViZIp6+QDihRRO5m
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 18:32:00 -0700
IronPort-SDR: LIrngR5ORlLq/W31K04xEqY50GaIBDJY0kNtPs4Ul5n/f7zFt5ADmec9PWrjSzU1eTMuY2SsIn
 5EGOJ/CKxhI++1vmW4+nkLOORRM10A1PGPYajLIABCLYHRE9rr0YBF4YT4TsjBK3ezzfyBxPNY
 2ZnlT2ezdX302FXaLT81+abdp4b/HpnR1tx9xcdooupWEQ7LH4XrTGKOqjc1E9+KlK7MIKWbOm
 OxWdSzHdwxGufzrZywDSKKvSJCgjvdW1WVJnBf9LbjuJrbeYbcXp0bdQTk0y4UhH4uyUtGg7su
 eXc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 19:01:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp26B0JTGz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 19:01:05 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651024864; x=1653616865; bh=aVEYVQf35+Uh7XzM6a1kJevWBsv5Uf3EWaU
        Sl6Zi8N0=; b=ZeDu48TMfnVRErQO6FzvxanT5ICopH9ORrv5SXtzpLS+TiS0T1L
        EslfKXJQX2/T9xqFy13DS5nGg7dJk8rDtOsBGPPKHcJJI+m7qA1MLvDaIJ998MgH
        pkygMtaPu/DXgGLux0zswiFie054ZB7iv3BT5mE/YBREugGO9xdrOgdEaf/dmqvB
        72o8h+CGsfiWyOv75mY/aKeyV0zqngz0FPYSa68ifoXAbXUoa7Gju5gS3swYI1cO
        oewUYT/UGVPUfenfsXFN51gWKa7q3FgurVlWK29TzRw0BM4jlt75vWJUNhN9Gb0i
        gzdM0ndxIZDSjQm+VOEsWjcQE1YiHf6F9sA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VSjXw6jW-LzY for <linux-scsi@vger.kernel.org>;
        Tue, 26 Apr 2022 19:01:04 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp25z67Pcz1Rvlc;
        Tue, 26 Apr 2022 19:00:55 -0700 (PDT)
Message-ID: <76a89205-f4f1-1e51-aa23-c8082bfefd3c@opensource.wdc.com>
Date:   Wed, 27 Apr 2022 11:00:54 +0900
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

Please reduce the distribution list. List servers (and email clients) are
complaining about it being too large.

>=20
> Overall series supports =E2=80=93
>=20
> 1. Driver
> - NVMe Copy command (single NS), including support in nvme-target (for
>     block and file backend)
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
