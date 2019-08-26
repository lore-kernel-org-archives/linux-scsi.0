Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5CCC3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 13:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1150821848
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 13:40:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RQunTSxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfHZNkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 09:40:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46212 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfHZNkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 09:40:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QDcc0F143599;
        Mon, 26 Aug 2019 13:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=JKWZzwUv3AdnbIRJIRy7ln4tMTqfIMb/O56RXfONqrk=;
 b=RQunTSxIEyUlnof+i4JlxYcZfVz06rGssbz041iP6CzB9P+2HkAsnteYcqc6/gNkPbJv
 /tqdgl4vS1+RGT2/v4jKX9SccZVc0S0IMiX40gUECuPNK4hhTtSAp1UhJFfFELmxjxUb
 QQ9Z1aTk8dOuYbAXdlx+jGa4lF5eLyVMpv6ytLgUgzgdeGJ5UH+Lp+9nKOm/kLJwo1En
 O8MHxlHtt2eJtuFtiQG0Wztg7paAQXqj6ID7pc9qW1NjFJ99truhYAMsWbDgXkJk8PAE
 ohVdqEM4FLfZ5zqxATTpZR3BA/5FaJsxaMy4vWZ66Pv2nHMhgEUGzznw9Lpkg3vx0kyL XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ujwvq9354-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 13:40:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QDYBYt054555;
        Mon, 26 Aug 2019 13:40:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ujw6uvfn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 13:40:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QDepw2007690;
        Mon, 26 Aug 2019 13:40:51 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 06:40:50 -0700
Date:   Mon, 26 Aug 2019 16:40:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Support dynamic unbounded SGL lists on G7
 hardware.
Message-ID: <20190826134044.GA8726@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260149
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch d79c9e9d4b3d: "scsi: lpfc: Support dynamic unbounded SGL
lists on G7 hardware." from Aug 14, 2019, leads to the following
static checker warning:

	drivers/scsi/lpfc/lpfc_init.c:4107 lpfc_new_io_buf()
	error: not allocating enough data 784 vs 768

drivers/scsi/lpfc/lpfc_init.c
  4071  /**
  4072   * lpfc_new_io_buf - IO buffer allocator for HBA with SLI4 IF spec
  4073   * @vport: The virtual port for which this call being executed.
  4074   * @num_to_allocate: The requested number of buffers to allocate.
  4075   *
  4076   * This routine allocates nvme buffers for device with SLI-4 interface spec,
  4077   * the nvme buffer contains all the necessary information needed to initiate
  4078   * an I/O. After allocating up to @num_to_allocate IO buffers and put
  4079   * them on a list, it post them to the port by using SGL block post.
  4080   *
  4081   * Return codes:
  4082   *   int - number of IO buffers that were allocated and posted.
  4083   *   0 = failure, less than num_to_alloc is a partial failure.
  4084   **/
  4085  int
  4086  lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
  4087  {
  4088          struct lpfc_io_buf *lpfc_ncmd;
  4089          struct lpfc_iocbq *pwqeq;
  4090          uint16_t iotag, lxri = 0;
  4091          int bcnt, num_posted;
  4092          LIST_HEAD(prep_nblist);
  4093          LIST_HEAD(post_nblist);
  4094          LIST_HEAD(nvme_nblist);
  4095  
  4096          /* Sanity check to ensure our sizing is right for both SCSI and NVME */
  4097          if (sizeof(struct lpfc_io_buf) > LPFC_COMMON_IO_BUF_SZ) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We made the lpfc_io_buf struct larger so now this check is more likely
to trigger.  Why don't we make this condition a BUILD_BUG_ON()?

  4098                  lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
  4099                                  "6426 Common buffer size %zd exceeds %d\n",
  4100                                  sizeof(struct lpfc_io_buf),
  4101                                  LPFC_COMMON_IO_BUF_SZ);
  4102                  return 0;

Zero means we're returning failure on this path.

  4103          }
  4104  
  4105          phba->sli4_hba.io_xri_cnt = 0;
  4106          for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
  4107                  lpfc_ncmd = kzalloc(LPFC_COMMON_IO_BUF_SZ, GFP_KERNEL);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Smatch generates a warning here.  It's obviously not a problem, because
of the earlier check.  I guess I don't really understand why
LPFC_COMMON_IO_BUF_SZ is useful when it's so close to sizeof(*lpfc_ncmd).

  4108                  if (!lpfc_ncmd)
  4109                          break;
  4110                  /*
  4111                   * Get memory from the pci pool to map the virt space to
  4112                   * pci bus space for an I/O. The DMA buffer includes the
  4113                   * number of SGE's necessary to support the sg_tablesize.
  4114                   */
  4115                  lpfc_ncmd->data = dma_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
  4116                                                    GFP_KERNEL,
  4117                                                    &lpfc_ncmd->dma_handle);
  4118                  if (!lpfc_ncmd->data) {

regards,
dan carpenter
