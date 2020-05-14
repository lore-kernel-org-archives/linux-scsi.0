Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866D7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 14:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1092070A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 14:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgENOLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 10:11:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42024 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgENOLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 10:11:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id y18so1355154pfl.9
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 07:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/ud6ZbYirQ/09o2P8MHEZwskgnXCDDQv7zBjWBX3HS0=;
        b=D0RYmBfiWC47HRWtszmC4FV2EwC7A530qtBxEf9cWNVwKQHWvQ5Fe4LkVQ6mMIZ7X2
         U9XYVVNBb00TQp4AmfhzVFsbc6GdrfgCxvpma1+PtEb9zDi1lpGxQopmjeKSmS8zd17T
         NcLowFOhfcnSPlur8WzrdL2DnWWRGehOo4h4CfXy2FokybJ1TQ6YFvABqyr+YOalCtyB
         26OtXTx+DOFwgrDOA/AmJfUD/U92CY/+77JVkeJXYBt3ADW2p/vInRQHsrAPn4brHUIR
         UdhToUbL0TU4DqHliiuVMcCOqxK9ohoE39AgRQEF+w5YjAA9y/ufc5LUNL4xsVN2VyF9
         fyLQ==
X-Gm-Message-State: AOAM531RzUB4o3vuiFbAzGt4DrfvjFa9inOSVLdgy4umtf2XATfp7X4o
        pFjcacx0S82fnJPkmrCmpig=
X-Google-Smtp-Source: ABdhPJwldOfrkZCQ4zWXwPRuT00aHVMEZ+33zA/zHqVqt3SNK0jrMSCPZSUs3cEq3Pt01UNDHSxPMQ==
X-Received: by 2002:a63:1e5f:: with SMTP id p31mr3966082pgm.19.1589465512430;
        Thu, 14 May 2020 07:11:52 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6c16:7f27:8c37:e02d? ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id p1sm18936061pjk.50.2020.05.14.07.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 07:11:51 -0700 (PDT)
Subject: Re: [PATCH 0/3] qla2xxx SAN Congestion Management (SCM) support
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <ad298d9c-92ad-0f7a-6873-6f346ce46c14@acm.org>
Date:   Thu, 14 May 2020 07:11:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-14 03:10, Nilesh Javali wrote:
> Please apply the qla2xxx patch series implementing SAN Congestion Management
> (SCM) support to the scsi tree at your earliest convenience.

Hi Nilesh,

This patch series introduces the following compiler warnings (W=1):

drivers/scsi/qla2xxx/qla_isr.c:27:1: warning: no previous prototype for
‘qla_link_integrity_tgt_stats_update’ [-Wmissing-prototypes]
   27 | qla_link_integrity_tgt_stats_update(struct fpin_descriptor
*fpin_desc,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:83:1: warning: no previous prototype for
‘qla_scm_process_link_integrity_d’ [-Wmissing-prototypes]
   83 | qla_scm_process_link_integrity_d(struct scsi_qla_host *vha,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:143:1: warning: no previous prototype for
‘qla_delivery_tgt_stats_update’ [-Wmissing-prototypes]
  143 | qla_delivery_tgt_stats_update(struct fpin_descriptor *fpin_desc,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:173:1: warning: no previous prototype for
‘qla_scm_process_delivery_notification_d’ [-Wmissing-prototypes]
  173 | qla_scm_process_delivery_notification_d(struct scsi_qla_host *vha,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:204:1: warning: no previous prototype for
‘qla_scm_set_target_device_state’ [-Wmissing-prototypes]
  204 | qla_scm_set_target_device_state(fc_port_t *fcport,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:227:1: warning: no previous prototype for
‘qla_peer_congestion_tgt_stats_update’ [-Wmissing-prototypes]
  227 | qla_peer_congestion_tgt_stats_update(struct fpin_descriptor
*fpin_desc,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:270:1: warning: no previous prototype for
‘qla_scm_process_peer_congestion_notification_d’ [-Wmissing-prototypes]
  270 | qla_scm_process_peer_congestion_notification_d(struct
scsi_qla_host *vha,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:313:1: warning: no previous prototype for
‘qla_scm_process_congestion_notification_d’ [-Wmissing-prototypes]
  313 | qla_scm_process_congestion_notification_d(struct scsi_qla_host *vha,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:343:1: warning: no previous prototype for
‘qla27xx_process_purex_fpin’ [-Wmissing-prototypes]
  343 | qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct
purex_item *item)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:1136:1: warning: no previous prototype
for ‘qla24xx_alloc_purex_item’ [-Wmissing-prototypes]
 1136 | qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
      | ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:1192:2: warning: no previous prototype
for ‘qla24xx_copy_std_pkt’ [-Wmissing-prototypes]
 1192 | *qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
      |  ^~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_isr.c:1213:1: warning: no previous prototype
for ‘qla27xx_copy_fpin_pkt’ [-Wmissing-prototypes]
 1213 | qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
      | ^~~~~~~~~~~~~~~~~~~~~
  CC [M]  drivers/scsi/qla2xxx/qla_gs.o
  CC [M]  drivers/scsi/qla2xxx/qla_dbg.o
  CC [M]  drivers/scsi/qla2xxx/qla_sup.o
  CC [M]  drivers/scsi/qla2xxx/qla_attr.o
  CC [M]  drivers/scsi/qla2xxx/qla_mid.o
  CC [M]  drivers/scsi/qla2xxx/qla_dfs.o
drivers/scsi/qla2xxx/qla_dfs.c: In function
‘qla2x00_dfs_tgt_port_database_show’:
drivers/scsi/qla2xxx/qla_dfs.c:107:1: warning: the frame size of 1280
bytes is larger than 1024 bytes [-Wframe-larger-than=]
  107 | }
      | ^


and also the following sparse complaints:

$ make M=drivers/scsi/qla2xxx C=2
  CHECK   drivers/scsi/qla2xxx/qla_os.c
  CC [M]  drivers/scsi/qla2xxx/qla_os.o
  CHECK   drivers/scsi/qla2xxx/qla_init.c
drivers/scsi/qla2xxx/qla_init.c:8520:22: warning: cast to restricted __le16
  CC [M]  drivers/scsi/qla2xxx/qla_init.o
  CHECK   drivers/scsi/qla2xxx/qla_mbx.c
  CC [M]  drivers/scsi/qla2xxx/qla_mbx.o
  CHECK   drivers/scsi/qla2xxx/qla_iocb.c
  CC [M]  drivers/scsi/qla2xxx/qla_iocb.o
  CHECK   drivers/scsi/qla2xxx/qla_isr.c
drivers/scsi/qla2xxx/qla_isr.c:27:1: warning: symbol
'qla_link_integrity_tgt_stats_update' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:106:38: warning: restricted __be32
degrades to integer
drivers/scsi/qla2xxx/qla_isr.c:83:1: warning: symbol
'qla_scm_process_link_integrity_d' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:143:1: warning: symbol
'qla_delivery_tgt_stats_update' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:173:1: warning: symbol
'qla_scm_process_delivery_notification_d' was not declared. Should it be
static?
drivers/scsi/qla2xxx/qla_isr.c:204:1: warning: symbol
'qla_scm_set_target_device_state' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:240:56: warning: incorrect type in
assignment (different base types)
drivers/scsi/qla2xxx/qla_isr.c:240:56:    expected unsigned int
[usertype] event_period
drivers/scsi/qla2xxx/qla_isr.c:240:56:    got restricted __be32
[usertype] event_period
drivers/scsi/qla2xxx/qla_isr.c:227:1: warning: symbol
'qla_peer_congestion_tgt_stats_update' was not declared. Should it be
static?
drivers/scsi/qla2xxx/qla_isr.c:270:1: warning: symbol
'qla_scm_process_peer_congestion_notification_d' was not declared.
Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:313:1: warning: symbol
'qla_scm_process_congestion_notification_d' was not declared. Should it
be static?
drivers/scsi/qla2xxx/qla_isr.c:343:1: warning: symbol
'qla27xx_process_purex_fpin' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:1135:19: warning: symbol
'qla24xx_alloc_purex_item' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:1192:1: warning: symbol
'qla24xx_copy_std_pkt' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_isr.c:1225:23: warning: restricted __le16
degrades to integer
drivers/scsi/qla2xxx/qla_isr.c:1225:23: warning: cast to restricted __le16
drivers/scsi/qla2xxx/qla_isr.c:1212:19: warning: symbol
'qla27xx_copy_fpin_pkt' was not declared. Should it be static?
  CC [M]  drivers/scsi/qla2xxx/qla_isr.o
  CHECK   drivers/scsi/qla2xxx/qla_gs.c
  CC [M]  drivers/scsi/qla2xxx/qla_gs.o
  CHECK   drivers/scsi/qla2xxx/qla_dbg.c
  CC [M]  drivers/scsi/qla2xxx/qla_dbg.o
  CHECK   drivers/scsi/qla2xxx/qla_sup.c
  CC [M]  drivers/scsi/qla2xxx/qla_sup.o
  CHECK   drivers/scsi/qla2xxx/qla_attr.c
  CC [M]  drivers/scsi/qla2xxx/qla_attr.o
  CHECK   drivers/scsi/qla2xxx/qla_mid.c
  CC [M]  drivers/scsi/qla2xxx/qla_mid.o
  CHECK   drivers/scsi/qla2xxx/qla_dfs.c
  CC [M]  drivers/scsi/qla2xxx/qla_dfs.o
drivers/scsi/qla2xxx/qla_dfs.c: In function
‘qla2x00_dfs_tgt_port_database_show’:
drivers/scsi/qla2xxx/qla_dfs.c:107:1: warning: the frame size of 1280
bytes is larger than 1024 bytes [-Wframe-larger-than=]
  107 | }
      | ^

Please fix these issues.

Thanks,

Bart.
