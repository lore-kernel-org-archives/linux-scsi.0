Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D089C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5287261057
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhDIGw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:52:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhDIGwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 02:52:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1396jnrF121452;
        Fri, 9 Apr 2021 06:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=qmPy8xDjuHJgIPWAtiaohwJ132a4j8fLJ9Ic+WPUots=;
 b=jTOd+60wO/tKAmFTxKRyXUpdiSBWq6mKqw627kLZ3JlzUSoyfnQ7C/lJwt9A+4Fpb7ng
 j9Lwp8HQ6C5MHsTVXvkPQ4VurUs/0fba5cdUAVYrQsaDxqTFrsyppbGh7LeJlI4jxcY0
 LqeR6ApAKz64h2dJUggaqCrak0cBE/dTX2R2jQ4dwLa9Tns1vdok+ZATUiJwaQ++29rd
 cTf0H9ABLbZDg3T0yEkdD/HwDb0F+fIY46rACW/s4fZQMiHfVjV5XdSmjLR6kUmcVNtm
 ZAUfzQtT50JrXgWFNBePTV00VVUEmuV9/Sh4U4DcqPtaqtwsfDFR39CTPs0nMhpDSqqs KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37rvas87np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 06:52:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1396jO0e176797;
        Fri, 9 Apr 2021 06:52:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 37rvb6895e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 06:52:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1396q8jP001219;
        Fri, 9 Apr 2021 06:52:08 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Apr 2021 23:52:07 -0700
Date:   Fri, 9 Apr 2021 09:52:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     don.brace@microchip.com
Cc:     storagedev@microchip.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: smartpqi: Add support for RAID5 and RAID6 writes
Message-ID: <YG/5kWHHAr7w5dU5@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090049
X-Proofpoint-GUID: mTXTq135l_xoS_XqsHfn0Grlipf77o2O
X-Proofpoint-ORIG-GUID: mTXTq135l_xoS_XqsHfn0Grlipf77o2O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1011
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090049
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Don Brace,

The patch 6702d2c40f31: "scsi: smartpqi: Add support for RAID5 and
RAID6 writes" from Mar 11, 2021, leads to the following static
checker warning:

	drivers/scsi/smartpqi/smartpqi_init.c:2664 pqi_calc_aio_r5_or_r6()
	warn: previously used 'rmd->blocks_per_row' as divisor (see line 2622)

drivers/scsi/smartpqi/smartpqi_init.c
  2607          rmd->r5or6_last_row_offset = do_div(tmpdiv, rmd->stripesize);
  2608          tmpdiv = rmd->r5or6_last_row_offset;
  2609          rmd->r5or6_last_row_offset = do_div(tmpdiv, rmd->blocks_per_row);
  2610          tmpdiv = rmd->r5or6_first_row_offset;
  2611          do_div(tmpdiv, rmd->strip_size);
  2612          rmd->first_column = rmd->r5or6_first_column = tmpdiv;
  2613          tmpdiv = rmd->r5or6_last_row_offset;
  2614          do_div(tmpdiv, rmd->strip_size);
  2615          rmd->r5or6_last_column = tmpdiv;
  2616  #else
  2617          rmd->first_row_offset = rmd->r5or6_first_row_offset =
  2618                  (u32)((rmd->first_block % rmd->stripesize) %
  2619                  rmd->blocks_per_row);
  2620  
  2621          rmd->r5or6_last_row_offset =
  2622                  (u32)((rmd->last_block % rmd->stripesize) %
  2623                  rmd->blocks_per_row);
                        ^^^^^^^^^^^^^^^^^^^
If ->blocks_per_row is zero then we are toasted long before the ...

  2624  
  2625          rmd->first_column =
  2626                  rmd->r5or6_first_row_offset / rmd->strip_size;
  2627          rmd->r5or6_first_column = rmd->first_column;
  2628          rmd->r5or6_last_column = rmd->r5or6_last_row_offset / rmd->strip_size;
  2629  #endif
  2630          if (rmd->r5or6_first_column != rmd->r5or6_last_column)
  2631                  return PQI_RAID_BYPASS_INELIGIBLE;
  2632  
  2633          /* Request is eligible. */
  2634          rmd->map_row =
  2635                  ((u32)(rmd->first_row >> raid_map->parity_rotation_shift)) %
  2636                  get_unaligned_le16(&raid_map->row_cnt);
  2637  
  2638          rmd->map_index = (rmd->first_group *
  2639                  (get_unaligned_le16(&raid_map->row_cnt) *
  2640                  rmd->total_disks_per_row)) +
  2641                  (rmd->map_row * rmd->total_disks_per_row) + rmd->first_column;
  2642  
  2643          if (rmd->is_write) {
  2644                  u32 index;
  2645  
  2646                  /*
  2647                   * p_parity_it_nexus and q_parity_it_nexus are pointers to the
  2648                   * parity entries inside the device's raid_map.
  2649                   *
  2650                   * A device's RAID map is bounded by: number of RAID disks squared.
  2651                   *
  2652                   * The devices RAID map size is checked during device
  2653                   * initialization.
  2654                   */
  2655                  index = DIV_ROUND_UP(rmd->map_index + 1, rmd->total_disks_per_row);
  2656                  index *= rmd->total_disks_per_row;
  2657                  index -= get_unaligned_le16(&raid_map->metadata_disks_per_row);
  2658  
  2659                  rmd->p_parity_it_nexus = raid_map->disk_data[index].aio_handle;
  2660                  if (rmd->raid_level == SA_RAID_6) {
  2661                          rmd->q_parity_it_nexus = raid_map->disk_data[index + 1].aio_handle;
  2662                          rmd->xor_mult = raid_map->disk_data[rmd->map_index].xor_mult[1];
  2663                  }
  2664                  if (rmd->blocks_per_row == 0)
                            ^^^^^^^^^^^^^^^^^^^^^^^^
... check on this line.

  2665                          return PQI_RAID_BYPASS_INELIGIBLE;
  2666  #if BITS_PER_LONG == 32
  2667                  tmpdiv = rmd->first_block;
  2668                  do_div(tmpdiv, rmd->blocks_per_row);
  2669                  rmd->row = tmpdiv;
  2670  #else
  2671                  rmd->row = rmd->first_block / rmd->blocks_per_row;
  2672  #endif
  2673          }
  2674  
  2675          return 0;
  2676  }

regards,
dan carpenter
