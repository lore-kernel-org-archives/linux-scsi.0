From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v1 1/9] ufs: sysfs: device descriptor
Date: Tue, 26 Dec 2017 09:57:54 +0800
Message-ID: <201712260943.hLjgelYQ%fengguang.wu@intel.com>
References: <1514190878-5571-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:54389 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLZB64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Dec 2017 20:58:56 -0500
Content-Disposition: inline
In-Reply-To: <1514190878-5571-2-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Hi Stanislav,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.15-rc5 next-20171222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Stanislav-Nijnikov/ufs-sysfs-read-only-access-to-device-descriptors-attributes-and-flags/20171226-075252
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +40 drivers/scsi/ufs/ufs-sysfs.c

    15	
    16	static inline ssize_t ufs_sysfs_read_desc_param(
    17		struct ufs_hba *hba, u8 desc_idn, u8 index, char *buf, u8 off,
    18		enum ufs_desc_param_size param_size)
    19	{
    20		int desc_len;
    21		int ret;
    22		u8 *desc_buf;
    23	
    24		if (ufshcd_map_desc_id_to_length(hba, desc_idn, &desc_len) ||
    25			off >= desc_len)
    26			return -EINVAL;
    27		desc_buf = kzalloc(desc_len, GFP_ATOMIC);
    28		if (!desc_buf)
    29			return -ENOMEM;
    30		ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
    31			desc_idn, index, 0, desc_buf, &desc_len);
    32		if (ret)
    33			return -EINVAL;
    34		switch (param_size) {
    35		case UFS_PARAM_BYTE_SIZE:
    36			ret = sprintf(buf, "0x%02X\n", desc_buf[off]);
    37			break;
    38		case UFS_PARAM_WORD_SIZE:
    39			ret = sprintf(buf, "0x%04X\n",
  > 40				be16_to_cpu(*((u16 *)(desc_buf + off))));
    41			break;
    42		case UFS_PARAM_DWORD_SIZE:
    43			ret = sprintf(buf, "0x%08X\n",
  > 44				be32_to_cpu(*((u32 *)(desc_buf + off))));
    45			break;
    46		case UFS_PARAM_QWORD_SIZE:
    47			ret = sprintf(buf, "0x%016llX\n",
  > 48				be64_to_cpu(*((u64 *)(desc_buf + off))));
    49			break;
    50		}
    51		kfree(desc_buf);
    52	
    53		return ret;
    54	}
    55	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
