Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5336D4E1;
	Sun,  8 Mar 2026 10:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772965933; cv=none; b=c4cHb0gJSc7D+FaaGWFRDEVRo/B9pdCV0DrskYNB1O3AwZ8sBDaQuiyEG4WMXbifLjfFMo40/ef2gX3Fl5R15D7g8XV86P1OuXzm8LEKrB2tF5J4s4xTpI+QCtAVYG0+Xc6eET2752RcjydGwjXqjGpao8G+I4mBNEE7vmNkrnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772965933; c=relaxed/simple;
	bh=J09zkkMc6nwZpCtbBGADOJnfZUNEnobOKYU2m/BqZbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRIaX/sqIfPruhxLhMcXG/xpzEgy2yVxyrhg7i7ibrpqfWnCM8+c8te/NWvXWbtzRoNjmdsBWGAx5zdiYr5F5MO6qd/Je6wl5alOwMZqY9cFqWiIj7hF74GSAinMXGPzhJ8gKAmk+sjWD6o1k04SBVoDOhCxIz7A6n3vHRsB6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xr684dgp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xr684dgp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772965931; x=1804501931;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J09zkkMc6nwZpCtbBGADOJnfZUNEnobOKYU2m/BqZbs=;
  b=Xr684dgpCkHAp+TAJkIMw0HIymjqZbWB23w+xhrPj1CzbAx0tNSg99Lm
   DJOTFcgMm56ZXw7MmBn8d3BnCZ1w//ZK1lEViCAI7siTlMTM2aGj6Q7YE
   srgOh7zroAAcIzU8ecr4PB7ViZxuFhAv6IXv3rAUsSbHFrpx52Wa3CGum
   qbBhk6dzvFxhiqtSFZ5maa/xQqBxrATIkMwW3HxlLOQOpjwv3SLPYE4eg
   3vQtAW4qu0O2udWc57rZx4iL/sD7wuoiBnJJuywOgCrq1w8xvbGoXPM2H
   U6cIP1nKU6kd8s0QqxY06aSLHpZGfX/GfE2suLPhIE5wLU4hPKirF8I64
   g==;
X-CSE-ConnectionGUID: p2YXAD72S3e61xZPojLVVg==
X-CSE-MsgGUID: Akokx9/QQsyiF0P3K088kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="85367074"
X-IronPort-AV: E=Sophos;i="6.23,108,1770624000"; 
   d="scan'208";a="85367074"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 03:32:10 -0700
X-CSE-ConnectionGUID: t8zOX5JEQn2k6A5dgS2Q6w==
X-CSE-MsgGUID: HVncasczSrez9SydP0b2aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,108,1770624000"; 
   d="scan'208";a="219441274"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 08 Mar 2026 03:32:03 -0700
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzBQV-0000000031t-1c3D;
	Sun, 08 Mar 2026 10:31:59 +0000
Date: Sun, 8 Mar 2026 18:31:44 +0800
From: kernel test robot <lkp@intel.com>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: Re: [PATCH v9 19/23] scsi: ufs: mediatek: Rework hardware version
 reading
Message-ID: <202603081809.R9OrrITa-lkp@intel.com>
References: <20260306-mt8196-ufs-v9-19-55b073f7a830@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-mt8196-ufs-v9-19-55b073f7a830@collabora.com>

Hi Nicolas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 11e703f54ac21f4dc609ea12ab578ffa47c87e11]

url:    https://github.com/intel-lab-lkp/linux/commits/Nicolas-Frattaroli/dt-bindings-phy-Add-mediatek-mt8196-ufsphy-variant/20260306-215930
base:   11e703f54ac21f4dc609ea12ab578ffa47c87e11
patch link:    https://lore.kernel.org/r/20260306-mt8196-ufs-v9-19-55b073f7a830%40collabora.com
patch subject: [PATCH v9 19/23] scsi: ufs: mediatek: Rework hardware version reading
config: arm-randconfig-002-20260308 (https://download.01.org/0day-ci/archive/20260308/202603081809.R9OrrITa-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260308/202603081809.R9OrrITa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603081809.R9OrrITa-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/ufs/host/ufs-mediatek.c:10:
   drivers/ufs/host/ufs-mediatek.c: In function 'ufs_mtk_get_hw_ip_version':
>> include/linux/bitfield.h:195:40: warning: result of '268435456 << 24' requires 54 bits to represent, but 'int' only has 32 bits [-Wshift-overflow=]
      *(_reg_p) |= (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)); \
                                           ^~
   drivers/ufs/host/ufs-mediatek.c:838:3: note: in expansion of macro 'FIELD_MODIFY'
      FIELD_MODIFY(MTK_UFS_VER_PREFIX_M, &version, BIT(28));
      ^~~~~~~~~~~~


vim +195 include/linux/bitfield.h

e2192de59e457a Johannes Berg      2023-01-18  142  
e2192de59e457a Johannes Berg      2023-01-18  143  /**
e2192de59e457a Johannes Berg      2023-01-18  144   * FIELD_PREP_CONST() - prepare a constant bitfield element
e2192de59e457a Johannes Berg      2023-01-18  145   * @_mask: shifted mask defining the field's length and position
e2192de59e457a Johannes Berg      2023-01-18  146   * @_val:  value to put in the field
e2192de59e457a Johannes Berg      2023-01-18  147   *
e2192de59e457a Johannes Berg      2023-01-18  148   * FIELD_PREP_CONST() masks and shifts up the value.  The result should
e2192de59e457a Johannes Berg      2023-01-18  149   * be combined with other fields of the bitfield using logical OR.
e2192de59e457a Johannes Berg      2023-01-18  150   *
e2192de59e457a Johannes Berg      2023-01-18  151   * Unlike FIELD_PREP() this is a constant expression and can therefore
e2192de59e457a Johannes Berg      2023-01-18  152   * be used in initializers. Error checking is less comfortable for this
e2192de59e457a Johannes Berg      2023-01-18  153   * version, and non-constant masks cannot be used.
e2192de59e457a Johannes Berg      2023-01-18  154   */
e2192de59e457a Johannes Berg      2023-01-18  155  #define FIELD_PREP_CONST(_mask, _val)					\
e2192de59e457a Johannes Berg      2023-01-18  156  	(								\
e2192de59e457a Johannes Berg      2023-01-18  157  		/* mask must be non-zero */				\
e2192de59e457a Johannes Berg      2023-01-18  158  		BUILD_BUG_ON_ZERO((_mask) == 0) +			\
e2192de59e457a Johannes Berg      2023-01-18  159  		/* check if value fits */				\
e2192de59e457a Johannes Berg      2023-01-18  160  		BUILD_BUG_ON_ZERO(~((_mask) >> __bf_shf(_mask)) & (_val)) + \
e2192de59e457a Johannes Berg      2023-01-18  161  		/* check if mask is contiguous */			\
e2192de59e457a Johannes Berg      2023-01-18  162  		__BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask))) +	\
e2192de59e457a Johannes Berg      2023-01-18  163  		/* and create the value */				\
e2192de59e457a Johannes Berg      2023-01-18  164  		(((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask))	\
e2192de59e457a Johannes Berg      2023-01-18  165  	)
e2192de59e457a Johannes Berg      2023-01-18  166  
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  167  /**
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  168   * FIELD_GET() - extract a bitfield element
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  169   * @_mask: shifted mask defining the field's length and position
7240767450d6d8 Masahiro Yamada    2017-10-03  170   * @_reg:  value of entire bitfield
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  171   *
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  172   * FIELD_GET() extracts the field specified by @_mask from the
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  173   * bitfield passed in as @_reg by masking and shifting it down.
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  174   */
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  175  #define FIELD_GET(_mask, _reg)						\
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  176  	({								\
2a6c045640c38a Geert Uytterhoeven 2025-11-06  177  		__BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");	\
2a6c045640c38a Geert Uytterhoeven 2025-11-06  178  		__FIELD_GET(_mask, _reg, "FIELD_GET: ");		\
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  179  	})
3e9b3112ec74f1 Jakub Kicinski     2016-08-31  180  
a256ae22570ee4 Luo Jie            2025-04-17  181  /**
a256ae22570ee4 Luo Jie            2025-04-17  182   * FIELD_MODIFY() - modify a bitfield element
a256ae22570ee4 Luo Jie            2025-04-17  183   * @_mask: shifted mask defining the field's length and position
a256ae22570ee4 Luo Jie            2025-04-17  184   * @_reg_p: pointer to the memory that should be updated
a256ae22570ee4 Luo Jie            2025-04-17  185   * @_val: value to store in the bitfield
a256ae22570ee4 Luo Jie            2025-04-17  186   *
a256ae22570ee4 Luo Jie            2025-04-17  187   * FIELD_MODIFY() modifies the set of bits in @_reg_p specified by @_mask,
a256ae22570ee4 Luo Jie            2025-04-17  188   * by replacing them with the bitfield value passed in as @_val.
a256ae22570ee4 Luo Jie            2025-04-17  189   */
a256ae22570ee4 Luo Jie            2025-04-17  190  #define FIELD_MODIFY(_mask, _reg_p, _val)						\
a256ae22570ee4 Luo Jie            2025-04-17  191  	({										\
a256ae22570ee4 Luo Jie            2025-04-17  192  		typecheck_pointer(_reg_p);						\
a256ae22570ee4 Luo Jie            2025-04-17  193  		__BF_FIELD_CHECK(_mask, *(_reg_p), _val, "FIELD_MODIFY: ");		\
a256ae22570ee4 Luo Jie            2025-04-17  194  		*(_reg_p) &= ~(_mask);							\
a256ae22570ee4 Luo Jie            2025-04-17 @195  		*(_reg_p) |= (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask));	\
a256ae22570ee4 Luo Jie            2025-04-17  196  	})
a256ae22570ee4 Luo Jie            2025-04-17  197  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
