Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6FDC33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECC7206ED
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgASU61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 15:58:27 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51707 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgASU61 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 15:58:27 -0500
Received: by mail-pj1-f66.google.com with SMTP id d15so5745565pjw.1;
        Sun, 19 Jan 2020 12:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sDRF0S+xxClm8hhrU117sfSXJq23LM47I4S3KoYDs2o=;
        b=ZsbDSAY4h2ReHyrouj0anoEbSWXXGACuh6Ajuxq+5LbQyrmYCILMoeKkrn73iVKCxu
         tnIdevfvGjWXKmFuLF0hOEBE2klVWx12qlNWpxXdr+sDbWVcdcNlfIxMSBf8zBje2+cy
         rC+i6D6YOLWPUnbK1VoeEEqcQFISpIw3+G+MpXugq/ej4y29ncpEBB60wT+TwDb1+2Qx
         VbHA/DnVejjHXiuvOPvw6Srk3SZbNyoaVjQBVLt1Tsa/MUqIVA57oIa/4VIrN/8HciH3
         i1LDmC/VLyWX4YV7h5xzJFBXvX4+j60DtQHCV9Ix22oud3lfNhRSIemQSYv0ysWs85f6
         yhsA==
X-Gm-Message-State: APjAAAVEaJPoRZEntqLnl9r+uku9/JJ5zsESAc4x8zDnTmXbSH6o+v6R
        HEoO788xp/Ee9q9pVtDweCtK2Zq3
X-Google-Smtp-Source: APXvYqx2MQ2Kiu0RvlhV4RdMSj3W4nMMbUVec6HjWSvK+LhwrqLu9rWnBbLib9yCrZPzcu/UwqNovA==
X-Received: by 2002:a17:902:7296:: with SMTP id d22mr11942628pll.55.1579467506627;
        Sun, 19 Jan 2020 12:58:26 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:781f:ca33:6085:f83a? ([2601:647:4000:d7:781f:ca33:6085:f83a])
        by smtp.gmail.com with ESMTPSA id b19sm35718450pfo.56.2020.01.19.12.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 12:58:25 -0800 (PST)
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD
 when HBA needs
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-6-ming.lei@redhat.com>
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
Message-ID: <5a467267-e990-45d1-4b69-18d8c0cd17b3@acm.org>
Date:   Sun, 19 Jan 2020 12:58:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119071432.18558-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-18 23:14, Ming Lei wrote:
> +static inline bool scsi_bypass_device_busy(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +
> +	if (!shost->hostt->no_device_queue_for_ssd)
> +		return false;
> +
> +	return blk_queue_nonrot(sdev->request_queue);
> +}

In other words, sdev->device_busy is maintained for all SCSI devices
except for those SSDs controlled by a SCSI LLD driver that has
no_device_queue_for_ssd set in its host template. I'd like to see
different behavior, namely that sdev->device_busy is not maintained for
any SSD except if that SSD really needs the sdev->device_busy counter.
The blacklist mechanism may be more appropriate to mark such SSDs than
the SCSI host template.

What I also noticed is that most scsi_bypass_device_busy() calls have an
exclamation mark (!) in front of these calls. I think that inverting the
return value and renaming this function into e.g.
scsi_maintain_device_busy() would result in code that is easier to read.

Thanks,

Bart.
