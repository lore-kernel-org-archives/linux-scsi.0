Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70639C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiBNCXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:23:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiBNCX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:23:29 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E01950B30
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805402; x=1676341402;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=WDEkOtqjCuABoESVUOYlNR0OSN8R3EFhvES+XSlxaR8=;
  b=lQ/2Ns9siikpDHwxt9WZ0ni1TS9tQKWYnVHeQ//KIbvkgMQxXyvpnQXr
   aqOeJKkuDN8U8/Kf4H6iny2os9gzvGTpa1uergnCj220wA+ls9reGR6Ku
   3LcBCpMd8YBVU8UVUypaxsa7Nzw6euIH3zmP0f6TXpZ7sU8qgCCWbgqMW
   e4SU1AcWA19pQXSGtkyvp4DRTsxr5NMTvn8dh73z9UefQ9EnD2ROBsFjF
   Bq49URd7npGwLMNPoTG/hg53uc28qsAFba8W0vh/pu3ipF/NBD3xzD+4d
   tnb2ZBsO8MvVZbERus4X9o3D2YbKhnB/R83ngeR8lQ5oF+TYd/FTVm+5g
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="197643433"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:23:22 +0800
IronPort-SDR: r7cbE5+dBHs9TSMBHuOWipj32wCvuIKS3KnYDuK7jr7NwLrYC517cgSIplhPmqspcFompwEVR6
 A/Ap8fWbjt64ttP3TNw1usu1oxHJDIG/Vral4sxovoXP8SgQdBXB4pKfhpOc+iPFwoQTAgDrN8
 MxVXcu6YsESXE6jrPx5cpUsTsvfpc7t6zCbY60M/ym6YYgWle8nYfh70J5bfe52irEvuq8gHBt
 218WKVi7hzySWmoRUL7gPt/2bdH95NBOgmB6e5roW1GDtpfabUl5lHI8Cks3Ovo0pb9c16g+sf
 5j2Qa2hz4yvjZfXe+W7QeRfV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:56:13 -0800
IronPort-SDR: LuU/025W3uaSdcNZsp16DLi85RrZ5cMW83Uamrhp1lNE+x2B84c7/IaCMGzOuA0A/AQdg3A8zz
 GgRYW7CN1wsoW8s5scfPCVGVqHfKjE1kiNhOvFgKiodbkc4fseFwsyj+HyAWWZjqxohffwQPHi
 vbmG0tChIwGw1BWlSy260yHjsbL/C0bKIJtLpp48jCQsvGSOt0XXXpB+rd0ffdzp+k1XXd+lCE
 4tzfPK2bZk532xKiyRuOKvbeFDEq84emOWUMjk4bPKWzS1F5I0qAaaGBdfQbIlF2Xwwd59oHr1
 CkQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:23:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxp162Gc9z1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:23:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644805401; x=1647397402; bh=WDEkOtqjCuABoESVUOYlNR0OSN8R3EFhvES
        +XSlxaR8=; b=IG445sSiyOW1k+wb4LnDjlc4kPi4X70G1/H54mzPaks1as5GZ6V
        CabbBM3MooQk6I2zPYVkZrt/ltpflodahPlfo1iDcbbPV9NsZBUdr34LXNaAcdK0
        bbFWT6xxn04gIAdnvWGNaXCCNCSkIhLUJvSZECrTuaBqn329TTcXg7iLvJvD5VgM
        LmpAV6+BV7J9UGnyVYTy393+BcwdZoX3oS/7HMchzcu3qSbFajXgLphu1n7eGgCy
        3osuY2+AK55tDE78SAoI7yALS3+3f8r1zaZG7Xuek9E2Dt2yhbrRl98uIwHO5OZh
        iVJ4Q8dNbdI3AU670stI0f0wIxCbaDMS0Rw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uDsJs5O4QpIO for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:23:21 -0800 (PST)
Received: from [10.89.82.198] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.82.198])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxp145b7rz1Rwrw;
        Sun, 13 Feb 2022 18:23:20 -0800 (PST)
Message-ID: <f14056ab-56a3-0d44-fd51-5a6386c60e03@opensource.wdc.com>
Date:   Mon, 14 Feb 2022 11:23:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v3 00/31] libsas and pm8001 fixes
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/14 11:17, Damien Le Moal wrote:
> This first part of this series (patches 1 to 24) fixes handling of NCQ
> NON DATA commands in libsas and many bugs in the pm8001 driver.
> 
> The fixes for the pm8001 driver include:
> * Suppression of all sparse warnings, fixing along the way many le32
>   handling bugs for big-endian architectures
> * Fix handling of NCQ NON DATA commands
> * Fix of tag values handling (0 *is* a valid tag value)
> * Fix many tag iand memory leaks in error path
> * Fix NCQ error recovery (abort all task execution) that was causing a
>   crash
> 
> The second part of the series (patches 25 to 31) iadd a small cleanup of
> libsas code and many simplifications of the pm8001 driver code.
> 
> With these fixes, libzbc test suite passes all test case. This test
> suite was used with an SMR drive for testing because it generates many
> NCQ NON DATA commands (for zone management commands) and also generates
> many NCQ command errors to check ASC/ASCQ returned by the device. With
> the test suite, the error recovery path was extensively exercised. The
> same tests were also executed with a SAS SMR drives to exercise the
> error path.
> 
> The patches are based on the 5.18/scsi-staging tree.

Martin,

Note that there is a conflict between 5.18/scsi-staging and 5.17-rc3/4 in the
pm8001 driver. And I need to touch rc3/rc4 code too. Could you rebase scsi-staging ?

Best regards.

> 
> Changes from v2:
> * Reorganized the series: fixes first, cleanups second.
> * Added more bug/leaks fix patches
> * Addressed Gary's comment for the ccb alloc helper (patch 28)
> * Rebased (and tested) all patches on 5.18/scsi-staging
> 
> Changes from v1:
> * Added reviewed-by tags
> * Addressed Christoph's comments on patch 4 and 8
> * Added patches 21 and 22 to fix 2 additional problems found while
>   preparing this v2 series
> * Added patch 23 and 24 to cleanup the code further.
> 
> Damien Le Moal (31):
>   scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
>   scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
>   scsi: pm8001: Fix pm8001_update_flash() local variable type
>   scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
>   scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
>   scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
>   scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
>   scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
>   scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
>   scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
>   scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
>   scsi: pm8001: Fix use of struct set_phy_profile_req fields
>   scsi: pm8001: Remove local variable in pm8001_pci_resume()
>   scsi: pm8001: Fix NCQ NON DATA command task initialization
>   scsi: pm8001: Fix NCQ NON DATA command completion handling
>   scsi: pm8001: Fix abort all task initialization
>   scsi: pm8001: Fix pm8001_tag_alloc() failures handling
>   scsi: pm8001: Fix pm80xx_chip_phy_ctl_req()
>   scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
>   scsi: pm8001: Fix tag values handling
>   scsi: pm8001: Fix task leak in pm8001_send_abort_all()
>   scsi: pm8001: Fix tag leaks on error
>   scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
>   scsi: pm8001: Fix process_one_iomb() kdoc comment
>   scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
>   scsi: pm8001: Simplify pm8001_get_ncq_tag()
>   scsi: pm8001: Cleanup pm8001_queue_command()
>   scsi: pm8001: Introduce ccb alloc/free helpers
>   scsi: pm8001: Simplify pm8001_mpi_build_cmd() interface
>   scsi: pm8001: Simplify pm8001_task_exec()
>   scsi: pm8001: Simplify pm8001_ccb_task_free()
> 
>  drivers/scsi/libsas/sas_ata.c     |  11 +-
>  drivers/scsi/pm8001/pm8001_ctl.c  |   5 +-
>  drivers/scsi/pm8001/pm8001_hwi.c  | 450 ++++++++++++-----------------
>  drivers/scsi/pm8001/pm8001_init.c |  11 +-
>  drivers/scsi/pm8001/pm8001_sas.c  | 297 +++++++++----------
>  drivers/scsi/pm8001/pm8001_sas.h  |  64 ++++-
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 458 ++++++++++++++----------------
>  drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
>  8 files changed, 605 insertions(+), 693 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
