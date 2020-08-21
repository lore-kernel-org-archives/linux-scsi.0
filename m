Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5548FC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 12:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D53B2078D
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 12:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i8+9eWRi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgHUMwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:52:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgHUMwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2020 08:52:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LCqKtF014164;
        Fri, 21 Aug 2020 12:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=LZkzl8F82CuWraAnHmvUtwkEEhi+mGS5o4I9w/gQk8g=;
 b=i8+9eWRiaQ1fWA1gnlwQR3L+5LBUGf7fe5TWusE9zRSS3yXrnlL6QpLxRPdgl6PAIpDp
 mZSHFPdth17tPiBjhYeH0Q1quveMQpD7j8FLyDBkhPS6gxxujSmtXh7FCuc1CXA64wSY
 bB9dJZdTqqC+6O7fSljFUXV7O8fW9R2iH04amGtpbTgwuK8unBGNs35cMYcOzqw3DTcE
 MMqAixhQKo9L83T8ve45aBdgGxcfA/OxoZCi/y7QbnmicuAkmq2t1ENDcikgz/K85OEG
 1Gk19gORXhOKfirhE2ZS4ALjFw57uRTUYaeTbvHn+m4s3AyvKOA023B+GnqlwFjWL9fs ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74rnw3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 12:52:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LCqYO6155899;
        Fri, 21 Aug 2020 12:52:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 331b2epd6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 12:52:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07LCqVvt029160;
        Fri, 21 Aug 2020 12:52:31 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 12:52:30 +0000
Date:   Fri, 21 Aug 2020 15:52:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jhasan@marvell.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: libfc: Free skb in fc_disc_gpn_id_resp() for
 valid cases
Message-ID: <20200821125226.GA34517@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=10 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=10 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210118
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Javed Hasan,

The patch ec007ef40abb: "scsi: libfc: Free skb in
fc_disc_gpn_id_resp() for valid cases" from Jul 29, 2020, leads to
the following static checker warning:

	drivers/scsi/libfc/fc_disc.c:638 fc_disc_gpn_id_resp()
	warn: '&fp->skb' double freed

drivers/scsi/libfc/fc_disc.c
   568  static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
   569                                  void *rdata_arg)
   570  {
   571          struct fc_rport_priv *rdata = rdata_arg;
   572          struct fc_rport_priv *new_rdata;
   573          struct fc_lport *lport;
   574          struct fc_disc *disc;
   575          struct fc_ct_hdr *cp;
   576          struct fc_ns_gid_pn *pn;
   577          u64 port_name;
   578  
   579          lport = rdata->local_port;
   580          disc = &lport->disc;
   581  
   582          if (PTR_ERR(fp) == -FC_EX_CLOSED)
   583                  goto out;
   584          if (IS_ERR(fp)) {
   585                  mutex_lock(&disc->disc_mutex);
   586                  fc_disc_restart(disc);
   587                  mutex_unlock(&disc->disc_mutex);

This call to fc_disc_restart(disc); was added in the commit, but it
wasn't mentioned in the commit message so I suspect it was committed by
mistake.

   588                  goto out;
   589          }
   590  
   591          cp = fc_frame_payload_get(fp, sizeof(*cp));
   592          if (!cp)
   593                  goto redisc;
   594          if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
   595                  if (fr_len(fp) < sizeof(struct fc_frame_header) +
   596                      sizeof(*cp) + sizeof(*pn))
   597                          goto redisc;
   598                  pn = (struct fc_ns_gid_pn *)(cp + 1);
   599                  port_name = get_unaligned_be64(&pn->fn_wwpn);
   600                  mutex_lock(&rdata->rp_mutex);
   601                  if (rdata->ids.port_name == -1)
   602                          rdata->ids.port_name = port_name;
   603                  else if (rdata->ids.port_name != port_name) {
   604                          FC_DISC_DBG(disc, "GPN_ID accepted.  WWPN changed. "
   605                                      "Port-id %6.6x wwpn %16.16llx\n",
   606                                      rdata->ids.port_id, port_name);
   607                          mutex_unlock(&rdata->rp_mutex);
   608                          fc_rport_logoff(rdata);
   609                          mutex_lock(&lport->disc.disc_mutex);
   610                          new_rdata = fc_rport_create(lport, rdata->ids.port_id);
   611                          mutex_unlock(&lport->disc.disc_mutex);
   612                          if (new_rdata) {
   613                                  new_rdata->disc_id = disc->disc_id;
   614                                  fc_rport_login(new_rdata);
   615                          }
   616                          goto free_fp;
   617                  }
   618                  rdata->disc_id = disc->disc_id;
   619                  mutex_unlock(&rdata->rp_mutex);
   620                  fc_rport_login(rdata);
   621          } else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
   622                  FC_DISC_DBG(disc, "GPN_ID rejected reason %x exp %x\n",
   623                              cp->ct_reason, cp->ct_explan);
   624                  fc_rport_logoff(rdata);
   625          } else {
   626                  FC_DISC_DBG(disc, "GPN_ID unexpected response code %x\n",
   627                              ntohs(cp->ct_cmd));
   628  redisc:
   629                  mutex_lock(&disc->disc_mutex);
   630                  fc_disc_restart(disc);
   631                  mutex_unlock(&disc->disc_mutex);
   632          }
   633  free_fp:
   634          fc_frame_free(fp);
                ^^^^^^^^^^^^^^^^^
Then this free was added.


   635  out:
   636          kref_put(&rdata->kref, fc_rport_destroy);
   637          if (!IS_ERR(fp))
   638                  fc_frame_free(fp);
                        ^^^^^^^^^^^^^^^^^
But there was already a free here so it was a double free.

   639  }

regards,
dan carpenter
