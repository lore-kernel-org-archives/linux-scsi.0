Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18877C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D91206EB
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IEn2Q+84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGYC4T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:56:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49232 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYC4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:56:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lRCB049043;
        Sat, 25 Jul 2020 02:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=feJZFLws9se5acZmDVp2LFR0v3P3Dy5grf1M+6tZ7XQ=;
 b=IEn2Q+84zFdHT2dnetzcdOPU4iQpKYtAzRmHb6uvd8jqacfJTr6flCbPp0KWS18GljxB
 wjKWmj7q7gwG20bM80Ly3d1T45nE+p9styvHWl9YLyrGaS2Xf/L2rTquZ9mBKDEMaMxa
 Rf1WncFubiLKjePAzyVjI5RPPA2ozX7Hq7iCzEt29AUQNxW7jcrDwb8r9NbdgRlQCtFg
 uqjknKceBgA1iYI6CuvKEVRYZCSS04YnP3HQgyhSWLkERhpt7m9I6oHkOO6S4zt/ntuY
 w9gWkk+8SwqFpFSdzleQTxLi+GPHPDtVtYWSQa/JVjwFJVm42iE4XfCCXbiB+5IWXEkl rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32d6kt64b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:56:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2rBvZ031878;
        Sat, 25 Jul 2020 02:56:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32g9uu7469-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:56:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2uCLp006023;
        Sat, 25 Jul 2020 02:56:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:56:12 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/40] Set 4: Next set of SCSI related W=1 warnings
Date:   Fri, 24 Jul 2020 22:56:11 -0400
Message-Id: <159564551272.19513.5349988908300664540.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Jul 2020 17:41:08 +0100, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 817.
> 
> Lee Jones (40):
>   scsi: arcmsr: arcmsr_hba: Remove statement with no effect
>   scsi: aic7xxx: aic79xx_core: Remove a bunch of unused variables
>   scsi: aacraid: sa: Add descriptions for missing parameters
>   scsi: aacraid: rkt: Add missing description for 'dev'
>   scsi: aacraid: nark: Add missing description for 'dev'
>   scsi: aic94xx: aic94xx_dev: Fix a couple of kerneldoc formatting
>     issues
>   scsi: aacraid: src: Add descriptions for missing parameters
>   scsi: aic94xx: aic94xx_tmf: Fix kerneldoc formatting issue with 'task'
>   scsi: pm8001: pm8001_sas: Fix strncpy() warning
>   scsi: pm8001: pm8001_sas: Mover function header and supply some
>     missing parameter descriptions
>   scsi: pm8001: pm8001_ctl: Add descriptions for unused 'attr' function
>     parameters
>   scsi: qla4xxx: ql4_init: Remove set but unused variable 'func_number'
>   scsi: qla4xxx: ql4_init: Check return value of pci_set_mwi()
>   scsi: qla4xxx: ql4_83xx: Move 'qla4_83xx_reg_tbl' from shared header
>   scsi: aic7xxx: aic79xx_core: Remove set but unused variables
>     'targ_info' and 'value'
>   scsi: pm8001: pm8001_hwi: Fix a bunch of kerneldoc issues
>   scsi: pm8001: pm80xx_hwi: Fix some function documentation issues
>   scsi: pm8001: pm8001_hwi: Remove a bunch of set but unused variables
>   scsi: qla4xxx: ql4_nx: Move 'qla4_82xx_reg_tbl' to the only place its
>     used
>   scsi: lpfc: lpfc_sli: Remove unused variable 'pg_addr'
>   scsi: qla4xxx: ql4_mbx: Fix-up incorrectly documented parameter
>   scsi: qla4xxx: ql4_iocb: Fix incorrectly named function parameter
>   scsi: lpfc: lpfc_sli: Fix-up around 120 documentation issues
>   scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
>   scsi: pm8001: pm80xx_hwi: Staticify 'pm80xx_pci_mem_copy' and
>     'mpi_set_phy_profile_req'
>   scsi: qla4xxx: ql4_os: Fix some kerneldoc parameter documentation
>     issues
>   scsi: qla4xxx: ql4_isr: Repair function documentation headers
>   scsi: lpfc: lpfc_mem: Provide description for lpfc_mem_alloc()'s
>     'align' param
>   scsi: qla4xxx: ql4_init: Document qla4xxx_process_ddb()'s 'conn_err'
>   scsi: lpfc: lpfc_ct: Fix-up formatting/docrot where appropriate
>   scsi: csiostor: csio_init: Fix misnamed function parameter
>   scsi: qla4xxx: ql4_nx: Remove three set but unused variables
>   scsi: qla4xxx: ql4_nx: Supply description for 'code'
>   scsi: csiostor: csio_lnode: Demote kerneldoc that fails to meet the
>     criteria
>   scsi: bfa: bfad_bsg: Staticify all local functions
>   scsi: lpfc: lpfc_sli: Ensure variable has the same stipulations as
>     code using it
>   scsi: sym53c8xx_2: sym_glue: Add missing description for 'pdev'
>   scsi: sym53c8xx_2: sym_hipd: Ensure variable has the same stipulations
>     as code using it
>   scsi: mvsas: mv_init: Move 'core_nr' inside #ifdef and remove unused
>     variable 'res_flag'
>   scsi: cxgbi: cxgb3i: cxgb3i: Remove bad documentation and demote
>     kerneldoc header
> 
> [...]

Applied to 5.9/scsi-next, thanks!

[01/40] scsi: arcmsr: arcmsr_hba: Remove statement with no effect
        https://git.kernel.org/mkp/scsi/c/7c7ef829ad08
[02/40] scsi: aic7xxx: aic79xx_core: Remove a bunch of unused variables
        https://git.kernel.org/mkp/scsi/c/84dc1a1d5459
[03/40] scsi: aacraid: Add descriptions for missing parameters
        https://git.kernel.org/mkp/scsi/c/baef36891460
[04/40] scsi: aacraid: Add missing description for 'dev'
        https://git.kernel.org/mkp/scsi/c/3c4538f80b09
[05/40] scsi: aacraid: Add missing description for 'dev'
        https://git.kernel.org/mkp/scsi/c/5d9d46b93d0a
[06/40] scsi: aic94xx: Fix a couple of kerneldoc formatting issues
        https://git.kernel.org/mkp/scsi/c/ee37a6e6d2a1
[07/40] scsi: aacraid: Add descriptions for missing parameters
        https://git.kernel.org/mkp/scsi/c/a13689118f63
[08/40] scsi: aic94xx: Fix kerneldoc formatting issue with 'task'
        https://git.kernel.org/mkp/scsi/c/45c21cec3867
[10/40] scsi: pm8001: Move function header and supply some missing parameter descriptions
        https://git.kernel.org/mkp/scsi/c/a0cf5ce40d12
[11/40] scsi: pm8001: Add descriptions for unused 'attr' function parameters
        https://git.kernel.org/mkp/scsi/c/cd2eebfd4028
[12/40] scsi: qla4xxx: Remove set but unused variable 'func_number'
        https://git.kernel.org/mkp/scsi/c/4c2de9c54112
[13/40] scsi: qla4xxx: Check return value of pci_set_mwi()
        https://git.kernel.org/mkp/scsi/c/b854460053ec
[14/40] scsi: qla4xxx: Move 'qla4_83xx_reg_tbl' from shared header
        https://git.kernel.org/mkp/scsi/c/3ca2c203ed99
[15/40] scsi: aic7xxx: Remove set but unused variables 'targ_info' and 'value'
        https://git.kernel.org/mkp/scsi/c/0683550b54c4
[16/40] scsi: pm8001: Fix a bunch of kerneldoc issues
        https://git.kernel.org/mkp/scsi/c/083645bab221
[17/40] scsi: pm8001: Fix some function documentation issues
        https://git.kernel.org/mkp/scsi/c/6ad4a51764a0
[18/40] scsi: pm8001: Remove a bunch of set but unused variables
        https://git.kernel.org/mkp/scsi/c/685f94794f9a
[19/40] scsi: qla4xxx: Move 'qla4_82xx_reg_tbl' to the only place its used
        https://git.kernel.org/mkp/scsi/c/f30554c27112
[20/40] scsi: lpfc: Remove unused variable 'pg_addr'
        https://git.kernel.org/mkp/scsi/c/3c1311ad837e
[21/40] scsi: qla4xxx: Fix-up incorrectly documented parameter
        https://git.kernel.org/mkp/scsi/c/0d5fea42989e
[22/40] scsi: qla4xxx: Fix incorrectly named function parameter
        https://git.kernel.org/mkp/scsi/c/67b8b93a559f
[23/40] scsi: lpfc: Fix-up around 120 documentation issues
        https://git.kernel.org/mkp/scsi/c/7af29d455362
[25/40] scsi: pm8001: Staticify 'pm80xx_pci_mem_copy' and 'mpi_set_phy_profile_req'
        https://git.kernel.org/mkp/scsi/c/ea310f574e73
[26/40] scsi: qla4xxx: Fix some kerneldoc parameter documentation issues
        https://git.kernel.org/mkp/scsi/c/cdeeb36d8f24
[27/40] scsi: qla4xxx: Repair function documentation headers
        https://git.kernel.org/mkp/scsi/c/fc5fba6e2ae2
[28/40] scsi: lpfc: Provide description for lpfc_mem_alloc()'s 'align' param
        https://git.kernel.org/mkp/scsi/c/c734de98a7bc
[29/40] scsi: qla4xxx: Document qla4xxx_process_ddb()'s 'conn_err'
        https://git.kernel.org/mkp/scsi/c/c0ad04b4b6d7
[30/40] scsi: lpfc: Fix-up formatting/docrot where appropriate
        https://git.kernel.org/mkp/scsi/c/6265bc4a41cd
[31/40] scsi: csiostor: Fix misnamed function parameter
        https://git.kernel.org/mkp/scsi/c/5446a91d8401
[32/40] scsi: qla4xxx: Remove three set but unused variables
        https://git.kernel.org/mkp/scsi/c/f67e81641db7
[33/40] scsi: qla4xxx: Supply description for 'code'
        https://git.kernel.org/mkp/scsi/c/653557df36e0
[34/40] scsi: csiostor: Demote kerneldoc that fails to meet the criteria
        https://git.kernel.org/mkp/scsi/c/fd4cdf6488d1
[35/40] scsi: bfa: Staticify all local functions
        https://git.kernel.org/mkp/scsi/c/3bbd8ef9f780
[36/40] scsi: lpfc: Ensure variable has the same stipulations as code using it
        https://git.kernel.org/mkp/scsi/c/11d8e56bfd3f
[37/40] scsi: sym53c8xx_2: Add missing description for 'pdev'
        https://git.kernel.org/mkp/scsi/c/633e19b57110
[38/40] scsi: sym53c8xx_2: Ensure variable has the same stipulations as code using it
        https://git.kernel.org/mkp/scsi/c/101706dc0a46
[39/40] scsi: mvsas: Move 'core_nr' inside #ifdef and remove unused variable 'res_flag'
        https://git.kernel.org/mkp/scsi/c/6eaa862747ea
[40/40] scsi: cxgb3i: Remove bad documentation and demote kerneldoc header
        https://git.kernel.org/mkp/scsi/c/f27e1bbc5cb2

-- 
Martin K. Petersen	Oracle Linux Engineering
