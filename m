Return-Path: <SRS0=obCF=3E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BA6C33C9E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 02:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDDA24658
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 02:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgAOC4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 21:56:17 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45661 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgAOC4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 21:56:16 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so7709948pfg.12
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 18:56:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=udS1wzBzu5YrUxKsOtOIiMYjlyF+k3lsqufQLT2hVHE=;
        b=g8/375E4oLGwA/VsECaQpouNmxZoZ1w61/6A5BD4e4L3AWIXr6OxRSQRJuE1zxPDLk
         VSOdUXLH7zT5kmhS2sIk+11DEYFqR4/p27DaxEywIjvJuYg4m4FMBas52KvjBxkdA0nD
         KtvjNLGwXde+J7iZhmA6Dn3KGM8DQfdZ6mMJd8BcFABSbkCnTzrCe3fLCFt/oLx4un2r
         1w8U3WH9YSwFLwL8I7HKNM9vSDqvz1sMFEY8b5Er1Rb5uhMkwsZTuFeJPhfigBowd7Qn
         qtKlvDIU13pPuUqklLBoOtb8bCPdhLCdYIdSAIZxkG7t930vg4aJpRcXjkb+A2Pfv+Bh
         h4Hw==
X-Gm-Message-State: APjAAAWQ2JyIkvuZ0WJg4waukfH+NmYQGaGFXitTkYqfrSMAaDKLoB2E
        Fzwuuk2ApPwjNXPU2tzcg9I=
X-Google-Smtp-Source: APXvYqwawlOaDeodrAWYHQ5mXabINZUX03dAqAmmGBYnzsRBXmghC80xzv+m+JaaQYito1Ab8/Cs0A==
X-Received: by 2002:a62:1b4d:: with SMTP id b74mr29701783pfb.59.1579056976164;
        Tue, 14 Jan 2020 18:56:16 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3c83:deec:6cc8:3148? ([2601:647:4000:d7:3c83:deec:6cc8:3148])
        by smtp.gmail.com with ESMTPSA id p5sm18563100pgs.28.2020.01.14.18.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 18:56:15 -0800 (PST)
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
To:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200112210846.13421-1-bvanassche@acm.org>
 <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
 <086f02b8-b8d8-5336-bf2c-031293d95890@acm.org>
 <c2baf21f60daf91593bc4a7088427257434e2040.camel@redhat.com>
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
Message-ID: <feb96690-cedb-586b-d040-127c9c6262c2@acm.org>
Date:   Tue, 14 Jan 2020 18:56:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <c2baf21f60daf91593bc4a7088427257434e2040.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-14 10:13, Ewan D. Milne wrote:
> Yes, but isn't that after "if (new_fcport == NULL)" where the code has
> put the previously allocated fcport into the &vha->vp_fcports list and
> was unable to allocate another one?

How about the (untested) patch below?

Thanks,

Bart.


From 436e1552f79b3a3b7d3f3b1dea1df27c33bd0d49 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 12 Jan 2020 09:17:37 -0800
Subject: [PATCH v2] qla2xxx: Fix a NULL pointer dereference in an error path

This patch fixes the following Coverity complaint:

FORWARD_NULL

qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}
qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c4e087217484..62df78258269 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5109,7 +5109,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
 	    &entries);
 	if (rval != QLA_SUCCESS)
-		goto cleanup_allocation;
+		goto err;

 	ql_dbg(ql_dbg_disc, vha, 0x2011,
 	    "Entries in ID list (%d).\n", entries);
@@ -5139,7 +5139,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		ql_log(ql_log_warn, vha, 0x2012,
 		    "Memory allocation failed for fcport.\n");
 		rval = QLA_MEMORY_ALLOC_FAILED;
-		goto cleanup_allocation;
+		goto err;
 	}
 	new_fcport->flags &= ~FCF_FABRIC_DEVICE;

@@ -5229,7 +5229,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				ql_log(ql_log_warn, vha, 0xd031,
 				    "Failed to allocate memory for fcport.\n");
 				rval = QLA_MEMORY_ALLOC_FAILED;
-				goto cleanup_allocation;
+				goto err;
 			}
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
@@ -5272,15 +5272,14 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			qla24xx_fcport_handle_login(vha, fcport);
 	}

-cleanup_allocation:
 	qla2x00_free_fcport(new_fcport);

-	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_disc, vha, 0x2098,
-		    "Configure local loop error exit: rval=%x.\n", rval);
-	}
+	return rval;

-	return (rval);
+err:
+	ql_dbg(ql_dbg_disc, vha, 0x2098,
+	       "Configure local loop error exit: rval=%x.\n", rval);
+	return rval;
 }

 static void
