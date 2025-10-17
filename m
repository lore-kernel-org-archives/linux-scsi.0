Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823DD32E73C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692304; cv=none; b=Al4QKLa4ED6GlzqNUq+VoYlBQjaE220dP+gd6wcVh6IsslERyh/EVWsSuZ0zHxuQ4bi6scAJtSwOrfgsAVE3fyoFFSKPVsCh5Ed9WBRIewyvrcBrPEJ3yQH1/YGxYDBwfzKNLqPqmoqpNXcQ0hJa6jENqdbtPN+p29UcIlrV/tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692304; c=relaxed/simple;
	bh=jDNmrH9oV5nkGCy3Ijf3en6eclIB3X+9GBUJsrncXfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRlWgf2nZ/8fl/L7TkAIs/9LoNPz5ZdySKXuxwGib2Ri8cmEEdAgWAWq17A1xyYWd+SySfvy2S8030qd4OKQDNxRKXyYhI4HMp3yolYC4V3s2rsyfelZohm2TWBHU0Z0GuQVluOa6oiCz6Z7Pv7XT9xUQ0uPRt/H9tBSdHFC9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=suwLOruR; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="suwLOruR"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-78113fdfd07so15518417b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 02:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760692301; x=1761297101; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/1GYl/yk6Sam9fIBoG9SiK34nTP0Coo0lGyUV9dWqdQ=;
        b=suwLOruR+T8VipgHqllDI4GA6sjkphTAMkThe4M+/WboInG/+oF+2+XN64/jQke9Jh
         LHoxy1IcOqKt5B3rq3h1NKFDiKj6556ioFq4SVXkl3K8M+3yDH+9b9qvgLmtRURZplQJ
         9K0wShrVxun/MwjSxQ5wV1ntujC2wYr1MBA0Wt5UTr17DYaJknApMaIS3/PFsMB3n+uo
         Db6J+vni4Jd/aybVVxnvTvrDaPdHwlv3q0zLkVyjdDm+032fC2aSMUm8Seh0uc15FdYk
         Xt1EQlzeNIu+wjj0VGZLAWy7PRSryVPBsnBhgIa+DCxHdPhhY94OTIGhOHFcJw6nx8vo
         ScEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760692301; x=1761297101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1GYl/yk6Sam9fIBoG9SiK34nTP0Coo0lGyUV9dWqdQ=;
        b=xVVBDU64jgAHv1zN+XPveR5UGzSblbJvDabnqupEW4iyeyq9LkQNJ6/ihF4RHwoR6z
         pop/pux46+JdEnJwEbyzAJXTtvxLZNC0y6VTBKJLF+RRRyzXt8/wxUpTeX4EO02t+k6I
         p4c+FZz9qQYj5mW5SR37GOPUNk1UiNV/EPHSP6PMcxx+IrlWPYaLrsQD7P/AM8CY11mQ
         zRgPcyr5lx6n16nhf/WWsn1yF2bdiLvPQyQLcDcOwt6gWanmhjv4mL84qy/XVPwhmjDf
         eRTggIFLJEqvDK0zoPMVnkvCVjwk8aV81mrSNandodX9gt8cpQykNIQhekowEDXboNCT
         ZEWA==
X-Forwarded-Encrypted: i=1; AJvYcCWNliP3vWKP5BlZNg8Lvnqpxcb7oV0pKhxIN7weEQYieQa3u2Xl0T1/gcXBDvvg3nGW+DvPKm+lpB05@vger.kernel.org
X-Gm-Message-State: AOJu0YwfV6UEZQSFUrcJ1e+cVmT/fCovT8Wl6a92St8IVKVWeFNq5Q3T
	HcY3R1MyF97kmGIefqUvgn9CZlZDTEkumZ5ATuLP/16E2L6SH8jj9K7k6nxQ7R5jPVwsG/asIxm
	ljva4pu3mTIKgakGNHAXy1mZs/yPyjYQTzPK6sZfBZA==
X-Gm-Gg: ASbGnctArHcwY4i56hhaE1LLZ8NexgD9+7ZbnCDAWEUWJMJ3DHbAMOOTOGg1Gtgb6x5
	XvYjaK0l4eaJ41TGYA/acG2vZgNVZSpDcaPSjVPWWlZ9uYbJ9lfj/k1MKRBvDBcOnIP5ia4PdL3
	RZZkTaTpKMC/p7jShigXNbJpqMMN6/U2tv52yRmv6WGHlLJJqEzkY4l9iwt5RoJLoZYXDwyXlf4
	2mCS61m6IkysBfcdCh5pv/9tc8IQ94+l4agZ2nETQDyAOF/oQPOOGHxJ412ymtyGnKhqo5N
X-Google-Smtp-Source: AGHT+IFLZ4nEbY8U1Ah0P65zbEh1FjU5spwfwgSTYseWxsnhjwkZWWax3YH1ox6L+1KmT+1tTJ7UvpXLIqSJVbTZxZ0=
X-Received: by 2002:a05:690e:4192:b0:636:1b01:63df with SMTP id
 956f58d0204a3-63e16168e5emr2752552d50.14.1760692301408; Fri, 17 Oct 2025
 02:11:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008201920.89575-4-beanhuo@iokpp.de> <202510100521.pnAPqTFK-lkp@intel.com>
 <eccb18abe33299edde64f96e0c3de88c4183cb78.camel@gmail.com>
In-Reply-To: <eccb18abe33299edde64f96e0c3de88c4183cb78.camel@gmail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 17 Oct 2025 11:11:05 +0200
X-Gm-Features: AS18NWA13YCigGWxYOYCDJShDi86eKoyREH8N9l4JY9xKwqxKwxeG5LwjHlJHpk
Message-ID: <CAPDyKFrsMxyD5ASGmsQ8658eBR0vHOSUqJ4axuSpAXuue6d5Uw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <huobean@gmail.com>
Cc: kernel test robot <lkp@intel.com>, avri.altman@wdc.com, avri.altman@sandisk.com, 
	bvanassche@acm.org, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, can.guo@oss.qualcomm.com, beanhuo@micron.com, 
	jens.wiklander@linaro.org, oe-kbuild-all@lists.linux.dev, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Oct 2025 at 10:19, Bean Huo <huobean@gmail.com> wrote:
>
>
> since the patch "rpmb: move rpmb_frame struct and constants to common header"
> has been queued in mmc git tree, I didn't add it patch in scsi tree for this
> version:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git/commit/?h=next
>
>
> do I need to add this queued patch for scsi tree as well?

I have just sent the patch to Linus to get included in rc2. Sorry, I
failed to send it for rc1.

That said, if you re-spin a version of the series that is based on rc2
on Monday that should work, I think.

Kind regards
Uffe

>
>
> Kind regards,
> Bean
>
>
> On Fri, 2025-10-10 at 05:36 +0800, kernel test robot wrote:
> > Hi Bean,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on v6.17]
> > [also build test ERROR on next-20251009]
> > [cannot apply to mkp-scsi/for-next jejb-scsi/for-next char-misc/char-misc-
> > testing char-misc/char-misc-next char-misc/char-misc-linus linus/master]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:
> > https://github.com/intel-lab-lkp/linux/commits/Bean-Huo/scsi-ufs-core-Convert-string-descriptor-format-macros-to-enum/20251009-204745
> > base:   v6.17
> > patch link:
> > https://lore.kernel.org/r/20251008201920.89575-4-beanhuo%40iokpp.de
> > patch subject: [PATCH v4 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
> > for UFS devices
> > config: sh-randconfig-002-20251010
> > (https://download.01.org/0day-ci/archive/20251010/202510100521.pnAPqTFK-lkp@in
> > tel.com/config)
> > compiler: sh4-linux-gcc (GCC) 15.1.0
> > reproduce (this is a W=1 build):
> > (https://download.01.org/0day-ci/archive/20251010/202510100521.pnAPqTFK-lkp@in
> > tel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version
> > of
> > the same patch/commit), kindly add following tags
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes:
> > > https://lore.kernel.org/oe-kbuild-all/202510100521.pnAPqTFK-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from include/linux/byteorder/big_endian.h:5,
> >                     from arch/sh/include/uapi/asm/byteorder.h:8,
> >                     from arch/sh/include/asm/bitops.h:10,
> >                     from include/linux/bitops.h:67,
> >                     from include/linux/log2.h:12,
> >                     from include/asm-generic/div64.h:55,
> >                     from ./arch/sh/include/generated/asm/div64.h:1,
> >                     from include/linux/math.h:6,
> >                     from include/linux/math64.h:6,
> >                     from include/linux/time.h:6,
> >                     from include/linux/stat.h:19,
> >                     from include/linux/module.h:13,
> >                     from drivers/ufs/core/ufs-rpmb.c:13:
> >    drivers/ufs/core/ufs-rpmb.c: In function 'ufs_rpmb_route_frames':
> >    drivers/ufs/core/ufs-rpmb.c:72:39: error: invalid use of undefined type
> > 'struct rpmb_frame'
> >       72 |         req_type = be16_to_cpu(frm_out->req_resp);
> >          |                                       ^~
> >    include/uapi/linux/byteorder/big_endian.h:43:51: note: in definition of
> > macro '__be16_to_cpu'
> >       43 | #define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
> >          |                                                   ^
> >    drivers/ufs/core/ufs-rpmb.c:72:20: note: in expansion of macro
> > 'be16_to_cpu'
> >       72 |         req_type = be16_to_cpu(frm_out->req_resp);
> >          |                    ^~~~~~~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:75:14: error: 'RPMB_PROGRAM_KEY' undeclared
> > (first use in this function)
> >       75 |         case RPMB_PROGRAM_KEY:
> >          |              ^~~~~~~~~~~~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:75:14: note: each undeclared identifier is
> > reported only once for each function it appears in
> >    drivers/ufs/core/ufs-rpmb.c:76:39: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       76 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len != sizeof(struct rpmb_frame))
> >          |                                       ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:76:80: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       76 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len != sizeof(struct rpmb_frame))
> >
> > |
> >    ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:79:14: error: 'RPMB_GET_WRITE_COUNTER'
> > undeclared (first use in this function)
> >       79 |         case RPMB_GET_WRITE_COUNTER:
> >          |              ^~~~~~~~~~~~~~~~~~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:80:39: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       80 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len != sizeof(struct rpmb_frame))
> >          |                                       ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:80:80: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       80 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len != sizeof(struct rpmb_frame))
> >
> > |
> >    ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:84:14: error: 'RPMB_WRITE_DATA' undeclared
> > (first use in this function)
> >       84 |         case RPMB_WRITE_DATA:
> >          |              ^~~~~~~~~~~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:85:38: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       85 |                 if (req_len % sizeof(struct rpmb_frame) || resp_len
> > != sizeof(struct rpmb_frame))
> >          |                                      ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:85:79: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       85 |                 if (req_len % sizeof(struct rpmb_frame) || resp_len
> > != sizeof(struct rpmb_frame))
> >
> > |
> >   ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:88:14: error: 'RPMB_READ_DATA' undeclared
> > (first use in this function); did you mean 'D_REAL_DATA'?
> >       88 |         case RPMB_READ_DATA:
> >          |              ^~~~~~~~~~~~~~
> >          |              D_REAL_DATA
> >    drivers/ufs/core/ufs-rpmb.c:89:39: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       89 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len % sizeof(struct rpmb_frame))
> >          |                                       ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:89:79: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >       89 |                 if (req_len != sizeof(struct rpmb_frame) ||
> > resp_len % sizeof(struct rpmb_frame))
> >
> > |
> >   ^~~~~~
> >    drivers/ufs/core/ufs-rpmb.c:109:43: error: invalid application of 'sizeof'
> > to incomplete type 'struct rpmb_frame'
> >      109 |                 memset(frm_resp, 0, sizeof(*frm_resp));
> >          |                                           ^
> >    drivers/ufs/core/ufs-rpmb.c:110:25: error: invalid use of undefined type
> > 'struct rpmb_frame'
> >      110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
> >          |                         ^~
> >    drivers/ufs/core/ufs-rpmb.c:110:50: error: 'RPMB_RESULT_READ' undeclared
> > (first use in this function)
> >      110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
> >          |                                                  ^~~~~~~~~~~~~~~~
> >    include/uapi/linux/byteorder/big_endian.h:42:51: note: in definition of
> > macro '__cpu_to_be16'
> >       42 | #define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
> >          |                                                   ^
> >    drivers/ufs/core/ufs-rpmb.c:110:38: note: in expansion of macro
> > 'cpu_to_be16'
> >      110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
> >          |                                      ^~~~~~~~~~~
> >    drivers/ufs/core/ufs-rpmb.c: At top level:
> > > > drivers/ufs/core/ufs-rpmb.c:135:5: error: redefinition of 'ufs_rpmb_probe'
> >      135 | int ufs_rpmb_probe(struct ufs_hba *hba)
> >          |     ^~~~~~~~~~~~~~
> >    In file included from drivers/ufs/core/ufs-rpmb.c:22:
> >    drivers/ufs/core/ufshcd-priv.h:424:19: note: previous definition of
> > 'ufs_rpmb_probe' with type 'int(struct ufs_hba *)'
> >      424 | static inline int ufs_rpmb_probe(struct ufs_hba *hba)
> >          |                   ^~~~~~~~~~~~~~
> > > > drivers/ufs/core/ufs-rpmb.c:229:6: error: redefinition of
> > > > 'ufs_rpmb_remove'
> >      229 | void ufs_rpmb_remove(struct ufs_hba *hba)
> >          |      ^~~~~~~~~~~~~~~
> >    drivers/ufs/core/ufshcd-priv.h:428:20: note: previous definition of
> > 'ufs_rpmb_remove' with type 'void(struct ufs_hba *)'
> >      428 | static inline void ufs_rpmb_remove(struct ufs_hba *hba)
> >          |                    ^~~~~~~~~~~~~~~
> >
> >
> > vim +/ufs_rpmb_probe +135 drivers/ufs/core/ufs-rpmb.c
> >
> >    133
> >    134  /* UFS RPMB device registration */
> >  > 135  int ufs_rpmb_probe(struct ufs_hba *hba)
> >    136  {
> >    137          struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> >    138          struct rpmb_dev *rdev;
> >    139          u8 cid[16] = { };
> >    140          int region;
> >    141          u8 *sn;
> >    142          u32 cap;
> >    143          int ret;
> >    144
> >    145          if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
> >    146                  dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
> >    147                  return -ENODEV;
> >    148          }
> >    149
> >    150          /* Get the UNICODE serial number data */
> >    151          sn = hba->dev_info.serial_number;
> >    152          if (!sn) {
> >    153                  dev_err(hba->dev, "Serial number not available\n");
> >    154                  return -EINVAL;
> >    155          }
> >    156
> >    157          INIT_LIST_HEAD(&hba->rpmbs);
> >    158
> >    159          /* Copy serial number into device ID (max 15 chars + NUL). */
> >    160          strscpy(cid, sn);
> >    161
> >    162          struct rpmb_descr descr = {
> >    163                  .type = RPMB_TYPE_UFS,
> >    164                  .route_frames = ufs_rpmb_route_frames,
> >    165                  .dev_id_len = sizeof(cid),
> >    166                  .reliable_wr_count = hba->dev_info.rpmb_io_size,
> >    167          };
> >    168
> >    169          for (region = 0; region < ARRAY_SIZE(hba-
> > >dev_info.rpmb_region_size); region++) {
> >    170                  cap = hba->dev_info.rpmb_region_size[region];
> >    171                  if (!cap)
> >    172                          continue;
> >    173
> >    174                  ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb),
> > GFP_KERNEL);
> >    175                  if (!ufs_rpmb) {
> >    176                          ret = -ENOMEM;
> >    177                          goto err_out;
> >    178                  }
> >    179
> >    180                  ufs_rpmb->hba = hba;
> >    181                  ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun-
> > >sdev_gendev;
> >    182                  ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
> >    183                  ufs_rpmb->dev.release = ufs_rpmb_device_release;
> >    184                  dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
> >    185
> >    186                  /* Set driver data BEFORE device_register */
> >    187                  dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
> >    188
> >    189                  ret = device_register(&ufs_rpmb->dev);
> >    190                  if (ret) {
> >    191                          dev_err(hba->dev, "Failed to register UFS RPMB
> > device %d\n", region);
> >    192                          put_device(&ufs_rpmb->dev);
> >    193                          goto err_out;
> >    194                  }
> >    195
> >    196                  /* Make CID unique for this region by appending region
> > numbe */
> >    197                  cid[sizeof(cid) - 1] = region;
> >    198                  descr.dev_id = cid;
> >    199                  descr.capacity = cap;
> >    200
> >    201                  /* Register RPMB device */
> >    202                  rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
> >    203                  if (IS_ERR(rdev)) {
> >    204                          dev_err(hba->dev, "Failed to register UFS RPMB
> > device.\n");
> >    205                          device_unregister(&ufs_rpmb->dev);
> >    206                          ret = PTR_ERR(rdev);
> >    207                          goto err_out;
> >    208                  }
> >    209
> >    210                  ufs_rpmb->rdev = rdev;
> >    211                  ufs_rpmb->region_id = region;
> >    212
> >    213                  list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
> >    214
> >    215                  dev_info(hba->dev, "UFS RPMB region %d registered
> > (capacity=%u)\n", region, cap);
> >    216          }
> >    217
> >    218          return 0;
> >    219  err_out:
> >    220          list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
> >    221                  list_del(&it->node);
> >    222                  device_unregister(&it->dev);
> >    223          }
> >    224
> >    225          return ret;
> >    226  }
> >    227
> >    228  /* UFS RPMB remove handler */
> >  > 229  void ufs_rpmb_remove(struct ufs_hba *hba)
> >    230  {
> >    231          struct ufs_rpmb_dev *ufs_rpmb, *tmp;
> >    232
> >    233          if (list_empty(&hba->rpmbs))
> >    234                  return;
> >    235
> >    236          /* Remove all registered RPMB devices */
> >    237          list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
> >    238                  dev_info(hba->dev, "Removing UFS RPMB region %d\n",
> > ufs_rpmb->region_id);
> >    239                  /* Remove from list first */
> >    240                  list_del(&ufs_rpmb->node);
> >    241                  /* Unregister device */
> >    242                  device_unregister(&ufs_rpmb->dev);
> >    243          }
> >    244
> >    245          dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
> >    246  }
> >    247
> >
>
