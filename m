Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41DBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 981D2205CB
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgGMQZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:25:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:20927 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGMQZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 12:25:06 -0400
Received: from localhost (varun.asicdesigners.com [10.193.191.116])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DGP3hc003747;
        Mon, 13 Jul 2020 09:25:03 -0700
Date:   Mon, 13 Jul 2020 21:55:02 +0530
From:   Varun Prakash <varun@chelsio.com>
To:     dan.carpenter@oracle.com
Cc:     linux-scsi@vger.kernel.org, varun@chelsio.com
Subject: Re: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation
 offload
Message-ID: <20200713162501.GB1780@chelsio.com>
References: <20200710141454.GA135495@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710141454.GA135495@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 10, 2020 at 05:14:54PM +0300, dan.carpenter@oracle.com wrote:
> Hello Varun Prakash,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI
> segmentation offload" from Jun 29, 2020, leads to the following
> Smatch complaint:
> 
>     drivers/scsi/cxgbi/libcxgbi.c:1892 cxgbi_conn_alloc_pdu()
>     warn: variable dereferenced before check 'cconn' (see line 1891)
> 
> drivers/scsi/cxgbi/libcxgbi.c
>   1890		struct cxgbi_conn *cconn = tcp_conn->dd_data;
>   1891		struct cxgbi_device *cdev = cconn->chba->cdev;
>                                             ^^^^^^^^^^^
> Unchecked dereference in old code.
> 
>   1892		struct cxgbi_sock *csk = (cconn && cconn->cep) ? cconn->cep->csk : NULL;
>                                           ^^^^^
> New code adds a check for NULL but it's too late.

cconn will never be NULL, I will post a patch to remove this NULL check.

> 
>   1893		struct iscsi_tcp_task *tcp_task = task->dd_data;
>   1894		struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
