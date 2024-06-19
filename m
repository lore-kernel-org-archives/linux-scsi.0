Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4DD6F305
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 06:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718780199; cv=none; b=lf7VCzj1K12saiKl5Qtok1cfO4n0LhtTwyKzE/nDSWWD8a1vqtKvvjnAg2i/VedzoT8q1QfwI4c7ZSdk8X+lnx/6EpbVoh+q+QgTMdQOvOknB7zcSssZ7ICA+NWnkim18J/VeuHKWmLH/tskPw+zgM9CYF5Ju1cMRnb0PCHuqIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718780199; c=relaxed/simple;
	bh=r80I+H50J7Vt2y3ht5SbXzI2PdSC7nVgPcfKXK7CRfw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Lp8GNRvHVd3wJRSYgI2AsZNCNLcNiywltLP49xln5a959u6ZPHKmQ5r8JiqcQ+JCkyuaKlRJyn/Ik2VjltyDRwBSgt5elown3atSOv6PwxRTwMMU/1W72sL0uJArmfRZsq+rJQ5mRD4VpqonuUFWs0/yGNNlGTE7Fzh0Qxygojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=Rx3OUxVF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="Rx3OUxVF"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f700e4cb92so54438645ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 23:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718780196; x=1719384996; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryEW32RS8Qz3RnhnRz7DXBVdc6x+wIrUy8ABLlADVtQ=;
        b=Rx3OUxVFkSlH2xJjpEgMgOOMSBmF+u5uoMom5yd/qBGOoIESmhSYijlNmisZa4OKET
         fZfEvxMRXw5au2AqSmuE3ddIXlDqd39mJd+phJBycpOGGILB14JrImZazwG4xAzOmVMH
         bPPgDxIhK0sCKsVIZZ2xFAYJ0YWJUUfxuk6dD83J/IRmjWqHOcCDRaEwumFIQfhJJ4RM
         XJcZDlxXBuh4P0DEwPD5B0KFhmRqvsr5R3OeIUrSavZtg4q7QW8qfxARPHrHDvCS6qn3
         oPb1gZBVHO1t1jjVHzw37l7m9KK8O5luGr0XLbzqHdIomIdjmP1kIDq6YTq0XBdwUJo5
         yQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718780196; x=1719384996;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryEW32RS8Qz3RnhnRz7DXBVdc6x+wIrUy8ABLlADVtQ=;
        b=lNxfaVmP7Geu7A7xIP8vPW3N2SdLuaf4Ax/TiVPAW2Dc9xKSolD17Mq2zxG8ZyPfvr
         RZgj+rtPJm7jcdP8yMhuFpyp5n/TfhP4WvGsRvPrYChOBgyjXvqB8j2zvIWslvvxtNk2
         koSjoIr9fBdueqA87YsFWNBldx2aaznBS9ROOgWDZ/6AoFgUigsZCJtauntZzgq2c8Nu
         e9FZUL7N15cJmPVhe21I/l+Mu6vBDBGwpzndIh1An7ZQRpSxG6LTgzHTGxJKShOjwei4
         P+oK8vfqVFx86i03ChyD3+dvnsZKA63oGZvgshOMViYGj6WUb9R8gNigls2tSnncZEPm
         zd5A==
X-Forwarded-Encrypted: i=1; AJvYcCVMteBFxmkSP86YobfHu1SMsKngeeqCePtqDumaoNAkmYbeyX6GDqKhQWroYQo2KjztFxLeIPTtM2OW4LHwlekRAtS+ACYZKpO0Uw==
X-Gm-Message-State: AOJu0YyixEdG6tctGKErCfEHiPov/68KGu26HlKvokRskZTYkestAjxo
	A6AONQH2+hlY+QWwvLrD6TBbTVRsUzgwleZA0AeEhsIn/RYBtEtEXAfhw08ZLqU=
X-Google-Smtp-Source: AGHT+IGWD8g0gPKpRYrSbW1FdV8KA3jTKYGrcoDDaHjVgfcPNht8petX1I/sDLGY6ESs14o/73kE0A==
X-Received: by 2002:a17:902:ced1:b0:1f7:123e:2c6f with SMTP id d9443c01a7336-1f9aa404a7fmr20736685ad.37.1718780195655;
        Tue, 18 Jun 2024 23:56:35 -0700 (PDT)
Received: from smtpclient.apple ([103.172.41.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1a1ebsm108957645ad.238.2024.06.18.23.56.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2024 23:56:35 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
From: Li Feng <fengli@smartx.com>
In-Reply-To: <ZnEsDHOAjODOS6HJ@infradead.org>
Date: Wed, 19 Jun 2024 14:56:18 +0800
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D8A1CB7B-7DE5-4078-9640-8674278E34C8@smartx.com>
References: <20240614160350.180490-1-fengli@smartx.com>
 <Zm_U_ZA96u2K6a6S@infradead.org>
 <44BCFE4F-AB66-4E6A-A181-E7D93847EF98@smartx.com>
 <ZnEsDHOAjODOS6HJ@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3731.300.101.1.3)



> 2024=E5=B9=B46=E6=9C=8818=E6=97=A5 14:41=EF=BC=8CChristoph Hellwig =
<hch@infradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Jun 17, 2024 at 05:03:03PM +0800, Li Feng wrote:
>>> But more importantly this doesn't really scale to all the variations
>>> of reported / guessed at probe time vs overriden.  I think you just
>>> need an explicit override flag that skips the discard settings.
>>>=20
>> I think we only need to prevent the temporary change of discard mode=20=

>> from UNMAP to WS16, and this patch should be enough.
>>=20
>> Maybe it is a good idea to remove the call to sd_config_discard=20
>> from read_capacity_16 . Because the unmap_alignment/ =
unmap_granularity
>> used by sd_config_discard are assigned in sd_read_block_limits.=20
>>=20
>> sd_read_block_limits is enough to negotiate the discard parameter.=20
>> It is redundant for read_capacity to modify the discard parameter.  =
In this way,=20
>> when the SCSI probe sends read_capacity first and then read block =
limits,=20
>> it avoids the change of discard from DISABLE to WS16 to UNMAP.
>=20
> Note that in the linux-next tree for 6.11 we're not only applying
> the discard choice to the queue_limits structure and not commixing
> it in read_capacity_16.  So it will be overriden before it gets
> actually applied.  Can you check that your issue doesn't show up in
> linux-next?
>=20

I pulled the latest linux-next and the problem still appeared.

[ 302.773386] sd 0:0:0:3: [sdc] tag#104 FAILED Result: hostbyte=3DDID_OK =
driverbyte=3DDRIVER_OK cmd_age=3D0s
[ 302.774839] sd 0:0:0:3: [sdc] tag#104 Sense Key : Illegal Request =
[current]
[ 302.775638] sd 0:0:0:3: [sdc] tag#104 Add. Sense: Invalid field in cdb
[ 302.776383] sd 0:0:0:3: [sdc] tag#104 CDB: Write same(16) 93 08 00 00 =
00 00 00 17 58 00 00 00 08 00 00 00
[ 302.777443] critical target error, dev sdc, sector 1529856 op =
0x3:(DISCARD) flags 0x4000 phys_seg 1 prio class 0

The discard mode will undergo a transition from UNMAP->WS16->UNMAP =
during the rescan process.

This results in an unexpected WS16 discard command.

We can see that the SCSI probe stage calls the following in sequence:
sd_read_capacity
sd_read_block_provisioning(sdkp);
sd_read_block_limits(sdkp, &lim);

We only need to negotiate the discard mode after these function calls =
are completed.
In this way, there will be no temporary unexpected changes to DISCARD.

Also fixed a problem where the old code could to WS16 in set =
read_capacity_16 when sdkp->lbpws =3D 0.
For my SCSI disk, lbpws is equal to 0.

How does this patch?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e01393ed4207..4c0962ebe7d5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2622,7 +2622,6 @@ static int read_capacity_16(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
              if (buffer[14] & 0x40) /* LBPRZ */
                      sdkp->lbprz =3D 1;

-               sd_config_discard(sdkp, lim, SD_LBP_WS16);
      }

      sdkp->capacity =3D lba + 1;
@@ -3271,8 +3270,6 @@ static void sd_read_block_limits(struct scsi_disk =
*sdkp,
              if (vpd->data[32] & 0x80)
                      sdkp->unmap_alignment =3D
                              get_unaligned_be32(&vpd->data[32]) & ~(1 =
<< 31);
-
-               sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
      }

out:
@@ -3670,6 +3667,7 @@ static int sd_revalidate_disk(struct gendisk =
*disk)
                      sd_zbc_read_zones(sdkp, &lim, buffer);
                      sd_read_cpr(sdkp);
              }
+               sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));

              sd_print_capacity(sdkp, old_capacity);


If it's OK, I'll submit v2.

Thanks,
Li

