Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C5027A10F
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 02:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775789346; cv=none; b=g5/UGvYxDADK7Mk83oCrz/Bss3yrPGOgDkuk9Ks5S+6tSgbSkRW6bBY+vcpH9Xz8nu5Qz5g5+wVC4bttVQabp8xlUw/L8iIwSmecO2Wk7gzOB1XS6j5yohjlzV5avKH9fOo4fcOwGAOpZkeOFHW3Rj0axTvMHhff3/usZrIz3I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775789346; c=relaxed/simple;
	bh=cQjuki/Yk1C6dbCuO7bJfbNeuJ8X13UPKlOALnbuc+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hAsdCSvc9603PKPrQBFfaTq4c2LTYQ1TV4KSx5tS/BYbWFGwpjekH6CIzVZt03YMpvO+6buxnXu3OMbtFutHIqKu8zjvEPqZWWsTRZ3lH2L5x6KoOTY5ONGQ4e/v/D6oi1vyOXqo8aliDwjnHyTFgKOWUivRg8fWsGDCGBeWj+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JI+QYUmb; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JI+QYUmb"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2cfd69b564dso2176947eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 19:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775789344; x=1776394144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JUwhPfOrcjiFviv0ScZUu0fmnLZYAthVYSSnbSs4M1g=;
        b=JI+QYUmbEErWRaKtaIdmOhcFyY2HQq3N77Qt4zX+y6FMAU2n0VBHvnU2fSEiq6RQ4l
         7tl+BhyyO6V3yqVdc+qX/Ah4bhpV3/VIwKNLzPZ8hX5PDNdU9kwp+LM8dd/Ux05OhG3K
         IoBqez1xa92+VwyJer9AuGuOs4L/BIu4EfMkk6yfkmAZ9jOoiEM59ngytV/I9PB+QqAu
         Sxxy/AxObi6uE8QtJeSabavNkaoj4Am74tVuFA1uo95cjxUU/bBzs3DK8gwI7j97fPZk
         +F50HHWuljHiH1IP/lzuzPJD1xQV+o90RQRdmw+BvrOy4hgmKS8COLvLANOK1vWlq2rK
         dN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775789344; x=1776394144;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JUwhPfOrcjiFviv0ScZUu0fmnLZYAthVYSSnbSs4M1g=;
        b=J4Hu8LQNNNqpP8jSIpw3M+yTgcGc5m5RMZCsAaowqT1kTh7nUgd2V6UeLka4lKsGxc
         LqEC7iGZo/Cn3jWWkffcVkXGNKZkEHHJ/Wkk0LipZCQc/0UspmTJCcqcR9Vpjf81/XNH
         v2AjfcnkFaC4fBhNDFqwrkIOF/AGIcD2t0GQFrZRe2INnEfZvuaVng4wBjTJgGa9h4fs
         XYx0B5yhnkzghtkyUt7Fc/4t+3KrhvU6aiq9sSmkvB8h27dPeklrehQZ6ExF4lqVmUqq
         Ryo8wFotyyKaL5Of3JVDtvwuHEHUizsf1tHGOCI1J7FuIz/MyTHBA4NEv/b5aqjQtkOM
         rMqw==
X-Forwarded-Encrypted: i=1; AJvYcCX7RoPJvXh16KRDOTcMqJKM5KasqOKAJZRx50VKy7TrpQsxby/vmk9aP3SorrwA+qo6ordQZLcEVSwz@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4j8GRJ/H5AwR39k2zBGpmf6wwJbrqJcnpYRlkBmGH3+aip6uC
	x5L2wWrSCCveE455KR6yYm4TemOc0jbbAOErL8VFt3AYWT7aEg1PsD+C
X-Gm-Gg: AeBDietVS0I+sCxQ3ro4iFQ1Ld4o3ye0z4lQ2xenZkQsOlktrVGWP/8oA02cWGmkNwq
	PqIHCfEMEpr8Tr7zRdx6Ca78BPNduxOOwuhXneThEprFLE7COHzKp6/iKSGhyXGMwUzFNH2kN2p
	GCAEn0JAmh7pXsYuqU3HuURpY3z8phB3Yyt5ADB1OJ8M5Ls4JhhDRCEyaniFxIO9X3VkQSCzgz8
	dc437TbVW/dn7bIQ3naGB6n2DCK+xKzEKFw9jKw/3hvLHjdJK97j8j+ZqUDIxdUoLhB20gaHOPz
	1kwK40FECLXCX67vGS7JerOhbE4IyVsONzTSA+p/n0ydEp3XtyNuqeKaJZDYkx1ulEDHc9pefkq
	/7ezQ26DncB/W/NPiVmye6gWefTT8BHy/oAfVQeYvurVH6C+cz5LBV1tjNdE9C0RfAJCDCGDoZB
	q591XJ4U7NIoFQPZs7RZwgt8pnq2lBrjDvDQU7yj5J
X-Received: by 2002:a05:7300:320a:b0:2c5:b23e:48a6 with SMTP id 5a478bee46e88-2d5888a1ae6mr996018eec.23.1775789344121;
        Thu, 09 Apr 2026 19:49:04 -0700 (PDT)
Received: from [192.168.86.23] ([136.25.189.61])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55f5c6b10sm2400912eec.5.2026.04.09.19.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 19:49:03 -0700 (PDT)
Message-ID: <0657bd66-43df-43b0-97d0-16288595e229@gmail.com>
Date: Thu, 9 Apr 2026 19:49:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: iscsi: reject invalid size Extended CDB
 AHS
To: Dmitry Bogdanov <d.bogdanov@yadro.com>, carlos.bilbao@kernel.org
Cc: bilbao@vt.edu, martin.petersen@oracle.com, kees@kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260404014429.115807-1-carlos.bilbao@kernel.org>
 <20260409024253.34926-1-carlos.bilbao@kernel.org>
 <20260409093159.GA902@yadro.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <20260409093159.GA902@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 4/9/26 02:31, Dmitry Bogdanov wrote:
> On Wed, Apr 08, 2026 at 07:42:53PM -0700, carlos.bilbao@kernel.org wrote:
>> From: Carlos Bilbao <carlos.bilbao@kernel.org>
>>
>> If ecdb_ahdr->ahslength is zero, two bugs follow:
>>
>>    kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15, ...)
>>
>> allocates 15 bytes, but the immediately following memcpy writes
>> ISCSI_CDB_SIZE (16) bytes into it, a one-byte heap overflow. Also:
>>
>>    memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>>             be16_to_cpu(ecdb_ahdr->ahslength) - 1);
>>
>> (u16)0 - 1 promotes to (int)-1 which converts to SIZE_MAX as size_t,
>> causing a massive out-of-bounds write.
>>
>> Reject ahslength == 0 with ISCSI_REASON_PROTOCOL_ERROR before the kmalloc.
>> Also reject ahslength values that exceed the actual AHS buffer advertised.
>>
>> Changes in v2:
>>
>> - Add bounds check: ahslength must not exceed (hdr->hlength * 4) - 3.
>> - Replace opaque ahslength + 15 with explicit cdb_length variable.
>>
>> Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
>> Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>
>> ---
>>   drivers/target/iscsi/iscsi_target.c | 23 +++++++++++++++++++----
>>   1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index e80449f6ce15..1a492965ebdf 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1100,6 +1100,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>          cdb = hdr->cdb;
>>
>>          if (hdr->hlength) {
>> +               u16 ahslength;
>> +
>>                  ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
>>                  if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
>>                          pr_err("Additional Header Segment type %d not supported!\n",
>> @@ -1108,14 +1110,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>                                  ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
>>                  }
>>
>> -               cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
>> -                             GFP_KERNEL);
>> +               ahslength = be16_to_cpu(ecdb_ahdr->ahslength);
>> +               if (!ahslength) {
>> +                       pr_err("Extended CDB AHS with zero length, protocol error.\n");
>> +                       return iscsit_add_reject_cmd(cmd,
>> +                               ISCSI_REASON_PROTOCOL_ERROR, buf);
>> +               }
>> +               if (ahslength > (hdr->hlength * 4) - 3) {
>> +                       pr_err("Extended CDB AHS length %u exceeds available buffer.\n",
>> +                              ahslength);
>> +                       return iscsit_add_reject_cmd(cmd,
>> +                               ISCSI_REASON_PROTOCOL_ERROR, buf);
>> +               }
>> +
>> +               u16 cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
> AFAIK, a variable declarationis allowed to be in the beginning of code block only.


You're absolutely right, happy to send v3 if the maintainer prefers.


>
>> +
>> +               cdb = kmalloc(cdb_length, GFP_KERNEL);
>>                  if (cdb == NULL)
>>                          return iscsit_add_reject_cmd(cmd,
>>                                  ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
>>                  memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
>> -               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>> -                      be16_to_cpu(ecdb_ahdr->ahslength) - 1);
>> +               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_SIZE);
>>          }
>>
>>          data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
>> --
>> 2.43.0
>>

Thanks,

Carlos

