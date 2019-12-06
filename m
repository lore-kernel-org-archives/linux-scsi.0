Return-Path: <SRS0=vR/u=Z4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D89EC43603
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 06:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2E424679
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 06:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfLFGDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:03:08 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:41760 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfLFGDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Dec 2019 01:03:08 -0500
Received: by mail-pj1-f66.google.com with SMTP id ca19so2280279pjb.8
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2019 22:03:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S9K0qlgA+xMNE/oCmcCQF01a7IIoBOwGeKYq5Af3zuo=;
        b=tFSy+Vreao45Wbl2fnNwQd2H3RGEi/sm15DYKHfDN9pZb8b+XLTuwcRIxg74C4owwV
         AoZncXKin+d+Njq1rScaLM1wH5dkBljXTt2vT302RdhmFduOXSwQwkXOuUZ2uG3Eq0sQ
         +CxBf1GyndNgycrFp2sAxyv3nAmLHozzNkSR9mnSuP3yeXCKe5jwPPWxEO2byZZnSikx
         AbGsloRV01pVmH30RrsiBUza0ZX4UbebrnPnUcvDgKxGHf+r+C3c5RvMow4Jkj4FBVOH
         XwCju6D/8DdlX+q7wedftfP9g4wRt5mJRRM5RCi3s8RIwTblkEsK4qeD2Ed90Suy8gan
         ilCQ==
X-Gm-Message-State: APjAAAWT+uj1VSqKJXxuwE5wc50SWURPvhxSP5IbWNF38wf+fAo6/H+p
        ckSbvWEyi5baE0GiAly3jT0=
X-Google-Smtp-Source: APXvYqy+vIrB9F/xb2sSpZJOExWp8RjuPM2m8gq1kEF2UPtT1mIzwM26rkDXK3pVZf8EpDd9JT739w==
X-Received: by 2002:a17:90a:2408:: with SMTP id h8mr13797578pje.123.1575612187170;
        Thu, 05 Dec 2019 22:03:07 -0800 (PST)
Received: from ?IPv6:2601:647:4001:f1bc:f465:52c4:66b8:23ac? ([2601:647:4001:f1bc:f465:52c4:66b8:23ac])
        by smtp.gmail.com with ESMTPSA id b21sm15425904pfp.0.2019.12.05.22.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 22:03:05 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
 <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
 <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
 <20191204120715.dgpr6xcdcckkae4q@SPB-NB-133.local>
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
Message-ID: <90b2e3b3-4d9c-d997-37a3-fb8c5bc6d927@acm.org>
Date:   Thu, 5 Dec 2019 22:03:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191204120715.dgpr6xcdcckkae4q@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-04 04:07, Roman Bolshakov wrote:
> Firmware can do implicit login, and this is how it worked for a while.
> 
> Then explicit login was introduced in the commit you referenced by
> setting bit 8 in IFCB fimwrare options 3 for 2600/2700 series and
> issuing ELS IOCB. However, for 2500 series, bit 7 should be set to
> disable implicit logins.
> 
> The latest commits that touches the bit is 8777e4314d397 ("scsi: qla2xxx:
> Migrate NVME N2N handling into state machine"). It sets the bit in
> qla24xx_nvram_config regadless of chip.
> 
> Does it help to set bit 7 in IFCB, firmware options 3 for 2500 series
> and leave the RESERVED S_ID field untouched?

Hi Roman,

Although I'm not sure whether the patch below is what you had in mind,
it triggers a long sequence of the following messages:

qla2xxx [0000:00:0a.0]-280d:8: HBA in N P2P topology.
qla2xxx [0000:00:0a.0]-2814:8: Configure loop -- dpc flags = 0x1260.
qla2xxx [0000:00:0a.0]-2811:8: Entries in ID list (1).
qla2xxx [0000:00:0a.0]-286a:8: qla2x00_configure_loop *** FAILED ***.
qla2xxx [0000:00:0a.0]-280d:8: HBA in N P2P topology.
qla2xxx [0000:00:0a.0]-2814:8: Configure loop -- dpc flags = 0x1260.
qla2xxx [0000:00:0a.0]-2811:8: Entries in ID list (1).
qla2xxx [0000:00:0a.0]-286a:8: qla2x00_configure_loop *** FAILED ***.

 diff --git a/drivers/scsi/qla2xxx/qla_init.c
b/drivers/scsi/qla2xxx/qla_init.c
index 6c28f38f8021..b7ab1a5d6b0e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7291,8 +7291,14 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	if (ql2xloginretrycount)
 		ha->login_retry_count = ql2xloginretrycount;

-	/* N2N: driver will initiate Login instead of FW */
-	icb->firmware_options_3 |= BIT_8;
+	if (!(IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) ||
+	      IS_QLA25XX(vha->hw))) {
+		/* N2N: driver will initiate login instead of FW */
+		icb->firmware_options_3 |= BIT_8;
+	} else {
+		/* Disable implicit N2N logins */
+		icb->firmware_options_3 |= BIT_7;
+	}

 	/* Enable ZIO. */
 	if (!vha->flags.init_done) {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..7aaabad88cf2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2656,10 +2656,13 @@ qla24xx_els_logo_iocb(srb_t *sp, struct
els_entry_24xx *els_iocb)
 	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	/* For SID the byte order is different than DID */
-	els_iocb->s_id[1] = vha->d_id.b.al_pa;
-	els_iocb->s_id[2] = vha->d_id.b.area;
-	els_iocb->s_id[0] = vha->d_id.b.domain;
+	if (!(IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) ||
+	      IS_QLA25XX(vha->hw))) {
+		/* For SID the byte order is different than DID */
+		els_iocb->s_id[1] = vha->d_id.b.al_pa;
+		els_iocb->s_id[2] = vha->d_id.b.area;
+		els_iocb->s_id[0] = vha->d_id.b.domain;
+	}

 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
 		els_iocb->control_flags = 0;
