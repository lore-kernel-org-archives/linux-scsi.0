Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8632C83000
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 14:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A6A214D8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 14:22:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jdCo2cJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgD2OWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:22:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgD2OWE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 10:22:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TEJIlo148862;
        Wed, 29 Apr 2020 14:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=H9uEbBR3MDj9zinlYeRHW8RlHFO48efwaGFSO+vzwrs=;
 b=jdCo2cJyu1My6BN1Kq8C9t+oWJoOLtQ8IQ/eOqnt2lRyRGCSCfMRlfG+6MvCGBZvXzZc
 8bFSMBUwIni//ZRrBK5fgu4rdfQpToowRV70/2Wt+57azws/qECdai8vGtyov1FFQTFo
 4NK4kMSRItxx4ywdJsslHUxrq1xjhHERmgEmabjTu262BElp4OReP38QG+cM0VJi/not
 +MhLWiaYa4cgZopM52BFqUC7XtuSm6IhpsQ2C2L04DkaM2tiCDMVMbM/5g8KfTx5A8NH
 whTYn1JvGdbNxibPt7vsxExU0YXoSWelRH0qjovfXmuMgU+7YpiUZl+20HtL5DpKXRCM /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p0beve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:22:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TEM0eT077596;
        Wed, 29 Apr 2020 14:22:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30pvd14rmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:22:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03TELtsT011571;
        Wed, 29 Apr 2020 14:21:55 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 07:21:55 -0700
Date:   Wed, 29 Apr 2020 17:21:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpt3sas: Handle RDPQ DMA allocation in same 4G
 region
Message-ID: <20200429142149.GA823478@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=10 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=10 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Suganath Prabu,

The patch 8012209eb26b: "scsi: mpt3sas: Handle RDPQ DMA allocation in
same 4G region" from Apr 23, 2020, leads to the following static
checker warning:

	drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
	warn: 'ioc->hpr_lookup' double freed

	drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
	warn: 'ioc->internal_lookup' double freed

drivers/scsi/mpt3sas/mpt3sas_base.c
  5202                  rdpq_sz = reply_post_free_sz * ioc->reply_queue_count;
  5203          ret = base_alloc_rdpq_dma_pool(ioc, rdpq_sz);
  5204          if (ret == -EAGAIN) {
  5205                  /*
  5206                   * Free allocated bad RDPQ memory pools.
  5207                   * Change dma coherent mask to 32 bit and reallocate RDPQ
  5208                   */
  5209                  _base_release_memory_pools(ioc);
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We added this free here which frees a whole ton of different stuff.

  5210                  ioc->use_32bit_dma = true;
  5211                  if (_base_config_dma_addressing(ioc, ioc->pdev) != 0) {
  5212                          ioc_err(ioc,
  5213                              "32 DMA mask failed %s\n", pci_name(ioc->pdev));
  5214                          return -ENODEV;
  5215                  }
  5216                  if (base_alloc_rdpq_dma_pool(ioc, rdpq_sz))
  5217                          return -ENOMEM;
  5218          } else if (ret == -ENOMEM)
  5219                  return -ENOMEM;
  5220          total_sz = rdpq_sz * (!ioc->rdpq_array_enable ? 1 :
  5221              DIV_ROUND_UP(ioc->reply_queue_count, RDPQ_MAX_INDEX_IN_ONE_CHUNK));
  5222          ioc->scsiio_depth = ioc->hba_queue_depth -
  5223              ioc->hi_priority_depth - ioc->internal_depth;
  5224  
  5225          /* set the scsi host can_queue depth
  5226           * with some internal commands that could be outstanding
  5227           */
  5228          ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
  5229          dinitprintk(ioc,
  5230                      ioc_info(ioc, "scsi host: can_queue depth (%d)\n",
  5231                               ioc->shost->can_queue));
  5232  
  5233          /* contiguous pool for request and chains, 16 byte align, one extra "
  5234           * "frame for smid=0
  5235           */
  5236          ioc->chain_depth = ioc->chains_needed_per_io * ioc->scsiio_depth;
  5237          sz = ((ioc->scsiio_depth + 1) * ioc->request_sz);
  5238  
  5239          /* hi-priority queue */
  5240          sz += (ioc->hi_priority_depth * ioc->request_sz);
  5241  
  5242          /* internal queue */
  5243          sz += (ioc->internal_depth * ioc->request_sz);
  5244  
  5245          ioc->request_dma_sz = sz;
  5246          ioc->request = dma_alloc_coherent(&ioc->pdev->dev, sz,
  5247                          &ioc->request_dma, GFP_KERNEL);
  5248          if (!ioc->request) {
  5249                  ioc_err(ioc, "request pool: dma_alloc_coherent failed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kB)\n",
  5250                          ioc->hba_queue_depth, ioc->chains_needed_per_io,
  5251                          ioc->request_sz, sz / 1024);
  5252                  if (ioc->scsiio_depth < MPT3SAS_SAS_QUEUE_DEPTH)
  5253                          goto out;
  5254                  retry_sz = 64;
  5255                  ioc->hba_queue_depth -= retry_sz;
  5256                  _base_release_memory_pools(ioc);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
And leads to some double frees here.

  5257                  goto retry_allocation;
  5258          }
  5259          memset(ioc->request, 0, sz);
  5260  
  5261          if (retry_sz)
  5262                  ioc_err(ioc, "request pool: dma_alloc_coherent succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kb)\n",
  5263                          ioc->hba_queue_depth, ioc->chains_needed_per_io,
  5264                          ioc->request_sz, sz / 1024);
  5265  

regards,
dan carpenter
