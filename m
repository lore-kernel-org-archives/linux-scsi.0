Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0E0C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 15:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiFWPTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiFWPTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 11:19:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BAF3EF03
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 08:19:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n12so12465957pfq.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yA01N1HZrz7IFp2nPZuMtqyDn5fkmLc6E3PjlvbacCk=;
        b=DE0y/yaO07zZaGm14AKI+4anw3l1f1t5p90lUFPnQa2XqHVQRgMuFxMxPkWNC9U/Vv
         5vfLflue20ii5bOZupy11bC5No32RURvGGzV7rFY36QQpm18+qWgO+TYEU1QP6Xh28Sj
         HmKDhWloJEByHAPqzlOlZP6BBiwH6i6SkUGX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yA01N1HZrz7IFp2nPZuMtqyDn5fkmLc6E3PjlvbacCk=;
        b=zjtbLf32uBx1IWfX4z+mXcFosFu2TGNPfL7QJZDg5euZkVnkHYNvI+l9aUtpUlXkLY
         LF+/RIeaUJfbyGiRXO2OIDM3jyvnkun82FhFaw472IrdqYdfoKDha/oQUsUdX+ZuqsbL
         943QCJbo8Q4PAt/s2wy8joTs1Xfnol2ZvmhwmQzzh3WRd/HEShVcwvdAJeZG2tJKt5Zj
         9BNH34+c9LHZuXqgVrHGqcVJ/6NN9SqVlbP7L266mhCtD4lZY4Tpre5Ie4QU4DsJP2kD
         JD6r7bHV5XnqRA30F56qvmwluZkpSodzen8/EFEF1FBWkX8Wd0kEGUxYkZKkMUSSTuYH
         bUfg==
X-Gm-Message-State: AJIora97mOAGFREHk7SEj1fvT4aSX5rhGnPyAfsHhP2XR45CWZKX9cey
        7ghFb2DdbAcbapWYTQHQ+FN90wMBqHtGog==
X-Google-Smtp-Source: AGRyM1s01FVaNRdRvtTZFv0QALTCLuTjlTI9CwJ7g0Z8GiYo7XO4v0FyBGCHcJ7iT2e3gnsINRPbwA==
X-Received: by 2002:a63:3308:0:b0:40c:7cb4:fe05 with SMTP id z8-20020a633308000000b0040c7cb4fe05mr8103564pgz.604.1655997590886;
        Thu, 23 Jun 2022 08:19:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ik25-20020a170902ab1900b00169e556f864sm13420982plb.218.2022.06.23.08.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 08:19:50 -0700 (PDT)
Date:   Thu, 23 Jun 2022 08:19:49 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 3/4][next] scsi: megaraid_sas: Replace one-element
 array with flexible-array member in MR_DRV_RAID_MAP
Message-ID: <202206230816.1383511C@keescook>
References: <cover.1628136510.git.gustavoars@kernel.org>
 <b43d4083d9788bb746dc0b2205d6a67ebb609b0d.1628136510.git.gustavoars@kernel.org>
 <202206221457.1A12D768EF@keescook>
 <20220623014533.GA7132@embeddedor>
 <20220623031401.GA8896@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623031401.GA8896@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 23, 2022 at 05:14:01AM +0200, Gustavo A. R. Silva wrote:
> On Thu, Jun 23, 2022 at 03:45:33AM +0200, Gustavo A. R. Silva wrote:
> > On Wed, Jun 22, 2022 at 03:26:38PM -0700, Kees Cook wrote:
> > > On Wed, Aug 04, 2021 at 11:20:04PM -0500, Gustavo A. R. Silva wrote:
> > > > Replace one-element array with a flexible-array member in struct
> > > > MR_DRV_RAID_MAP and use the flex_array_size() helper.
> > > > 
> > > > This helps with the ongoing efforts to globally enable -Warray-bounds
> > > > and get us closer to being able to tighten the FORTIFY_SOURCE routines
> > > > on memcpy().
> > > > 
> > > > Link: https://en.wikipedia.org/wiki/Flexible_array_member
> > > > Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
> > > > Link: https://github.com/KSPP/linux/issues/79
> > > > Link: https://github.com/KSPP/linux/issues/109
> > > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > 
> > > I'd really like to see this fixed. :) I'm running into this 1-element
> > > array problem now with UBSAN_BOUNDS:
> > 
> > Wow; another forgoten patch from the times we didn't have Patchwork. :) 
> > 
> > > 
> > > [   10.011173] UBSAN: array-index-out-of-bounds in /build/linux-WLUive/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
> > > [   10.087824] index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
> > > 
> > > and I'm not the only one:
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=215943
> > 
> > It's actually great that other people are running into these issues now.
> > That could only means that we should fixed ASAP. :)
> > 
> > We also have this other series that hasn't been applied yet:
> > 
> > https://lore.kernel.org/linux-hardening/cover.1645513670.git.gustavoars@kernel.org/
> > 
> > > 
> > > > ---
> > > > Changes in v2:
> > > >  - None.
> > > > 
> > > >  drivers/scsi/megaraid/megaraid_sas_fp.c     | 6 +++---
> > > >  drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
> > > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> > > > index da1cad1ee123..9cb36ef96c2c 100644
> > > > --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> > > > +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> > > > @@ -229,8 +229,8 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
> > > >  					le32_to_cpu(desc_table->raid_map_desc_offset));
> > > >  				memcpy(pDrvRaidMap->ldSpanMap,
> > > >  				       fw_map_dyn->ld_span_map,
> > > > -				       sizeof(struct MR_LD_SPAN_MAP) *
> > > > -				       le32_to_cpu(desc_table->raid_map_desc_elements));
> > > > +				       flex_array_size(pDrvRaidMap, ldSpanMap,
> > > > +				       le32_to_cpu(desc_table->raid_map_desc_elements)));
> > > >  			break;
> > > >  			default:
> > > >  				dev_dbg(&instance->pdev->dev, "wrong number of desctableElements %d\n",
> > > > @@ -254,7 +254,7 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
> > > >  			pDrvRaidMap->ldTgtIdToLd[i] =
> > > >  				(u16)fw_map_ext->ldTgtIdToLd[i];
> > > >  		memcpy(pDrvRaidMap->ldSpanMap, fw_map_ext->ldSpanMap,
> > > > -		       sizeof(struct MR_LD_SPAN_MAP) * ld_count);
> > > > +		       flex_array_size(pDrvRaidMap, ldSpanMap, ld_count));
> > > >  		memcpy(pDrvRaidMap->arMapInfo, fw_map_ext->arMapInfo,
> > > >  		       sizeof(struct MR_ARRAY_INFO) * MAX_API_ARRAYS_EXT);
> > > >  		memcpy(pDrvRaidMap->devHndlInfo, fw_map_ext->devHndlInfo,
> > > > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> > > > index 9adb8b30f422..5fe2f7a6eebe 100644
> > > > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> > > > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> > > > @@ -1182,7 +1182,7 @@ struct MR_DRV_RAID_MAP {
> > > >  		devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES_DYN];
> > > >  	u16 ldTgtIdToLd[MAX_LOGICAL_DRIVES_DYN];
> > > >  	struct MR_ARRAY_INFO arMapInfo[MAX_API_ARRAYS_DYN];
> > > > -	struct MR_LD_SPAN_MAP      ldSpanMap[1];
> > > > +	struct MR_LD_SPAN_MAP      ldSpanMap[];
> > > >  
> > > >  };
> > > >  
> > > 
> > > I think this patch is incomplete, and the wrapping struct needs to be
> > > adjusted too:
> > > 
> > > @@ -1193,7 +1193,7 @@ struct MR_DRV_RAID_MAP {
> > >  struct MR_DRV_RAID_MAP_ALL {
> > >  
> > >         struct MR_DRV_RAID_MAP raidMap;
> > > -       struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN - 1];
> > > +       struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN];
> > >  } __packed;
> 
> BTW, I'd really like to get some input from the maintainers of this
> code. :)

Agreed, though if we get 0 output from a diffoscope of the object files,
I think it's safe to carry such patches in our trees. This is how I've
been testing:

$ make allmodconfig
$ ./scripts/config -d GCOV_KERNEL -d KCOV -d GCC_PLUGINS -d IKHEADERS -d KASAN -d UBSAN
$ make olddefconfig
$ make the/path/to/code.o
$ cp the/path/to/code.o the/path/to/code.before
$ *apply patch*
$ make the/path/to/code.o
$ cp the/path/to/code.o the/path/to/code.after
$ diffoscope the/path/to/code.before the/path/to/code.after


-- 
Kees Cook
