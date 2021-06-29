Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81016C11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 07:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC3761DCA
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 07:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhF2HDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 03:03:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9902 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232041AbhF2HDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 03:03:01 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T6qCkD017030;
        Tue, 29 Jun 2021 07:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=5LtOntajykpJ+8gNuE/dotnboFmSrVQFHVl9YsopYDk=;
 b=sdOS+HQmbSM0zQp8oH5GkbvWywod3laBm1W/ocHQA8yXh112s3irkcjuK1Wk2DARk7kV
 IS4MiK1YuaIJXGROPpk9l+sFxKrRZW3y1Yuoo5pmnFIg2+hFXqNWoyjJGMjlaOoUCyLl
 DNHp0VwhZJT4EnGnflyE0U7tlTTB7zje19Da1H9z5tsAurHhnz/5ttBUDoDkyOi6fMfg
 CcVah+/Kq/Hx5e/KziaN0GaBVAeAzi8tlyGg2hmepfveLQaM8VzgndwW87mzqLctU+M+
 ZdzP+D/dl4tAUWE++kIzYzYn04cb//urfGfNi+CkMsVr9jeFkI4VnUJs3K9HhlnYbucJ QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f7uu2nkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 07:00:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T6xoeU055836;
        Tue, 29 Jun 2021 07:00:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 39dv251ms8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 07:00:23 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15T70Mw2058603;
        Tue, 29 Jun 2021 07:00:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 39dv251mrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 07:00:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15T70J6g020274;
        Tue, 29 Jun 2021 07:00:19 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jun 2021 00:00:19 -0700
Date:   Tue, 29 Jun 2021 10:00:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, mwilck@suse.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kbuild] Re: [PATCH v4 2/3] scsi: scsi_ioctl: add
 sg_io_to_blk_status()
Message-ID: <202106282356.dKNkiTUO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628095210.26249-3-mwilck@suse.com>
Message-ID-Hash: IRD7CG4UZAG2EYZJ7F52EJJBUWZF7ZWB
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: DqxcFkkAexUvoS_yb1Y_fZ6GTTM60I3y
X-Proofpoint-GUID: DqxcFkkAexUvoS_yb1Y_fZ6GTTM60I3y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

url:    https://github.com/0day-ci/linux/commits/mwilck-suse-com/scsi-dm-dm_blk_ioctl-implement-failover-for-SG_IO-on-dm-multipath/20210628-175410 
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git  for-next
config: xtensa-randconfig-s032-20210628 (attached as .config)
compiler: xtensa-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.3-341-g8af24329-dirty
        # https://github.com/0day-ci/linux/commit/259453ca972ae531cfdca07cbf4d6bb09b8f8c9f 
        git remote add linux-review https://github.com/0day-ci/linux 
        git fetch --no-tags linux-review mwilck-suse-com/scsi-dm-dm_blk_ioctl-implement-failover-for-SG_IO-on-dm-multipath/20210628-175410
        git checkout 259453ca972ae531cfdca07cbf4d6bb09b8f8c9f
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=xtensa SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> block/scsi_ioctl.c:937:24: sparse: sparse: dubious: !x & y

vim +937 block/scsi_ioctl.c

259453ca972ae5 Martin Wilck 2021-06-28  932  blk_status_t sg_io_to_blk_status(struct sg_io_hdr *hdr)
259453ca972ae5 Martin Wilck 2021-06-28  933  {
259453ca972ae5 Martin Wilck 2021-06-28  934  	int result;
259453ca972ae5 Martin Wilck 2021-06-28  935  	blk_status_t sts;
259453ca972ae5 Martin Wilck 2021-06-28  936  
259453ca972ae5 Martin Wilck 2021-06-28 @937  	if (!hdr->info & SG_INFO_CHECK)
                                                    ^
Should be if (!(hdr->info & SG_INFO_CHECK))

259453ca972ae5 Martin Wilck 2021-06-28  938  		return BLK_STS_OK;
259453ca972ae5 Martin Wilck 2021-06-28  939  
259453ca972ae5 Martin Wilck 2021-06-28  940  	result = hdr->status |
259453ca972ae5 Martin Wilck 2021-06-28  941  		(hdr->msg_status << 8) |
259453ca972ae5 Martin Wilck 2021-06-28  942  		(hdr->host_status << 16) |
259453ca972ae5 Martin Wilck 2021-06-28  943  		(hdr->driver_status << 24);
259453ca972ae5 Martin Wilck 2021-06-28  944  
259453ca972ae5 Martin Wilck 2021-06-28  945  	sts = __scsi_result_to_blk_status(&result, result);
259453ca972ae5 Martin Wilck 2021-06-28  946  	hdr->host_status = host_byte(result);
259453ca972ae5 Martin Wilck 2021-06-28  947  
259453ca972ae5 Martin Wilck 2021-06-28  948  	return sts;
259453ca972ae5 Martin Wilck 2021-06-28  949  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 

_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

