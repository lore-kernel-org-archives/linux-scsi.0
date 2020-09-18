Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F05C43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4277221707
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIRTHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 15:07:53 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:56080 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgIRTHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 15:07:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 680D8182CF666;
        Fri, 18 Sep 2020 19:07:51 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: grape33_3e10a6e2712d
X-Filterd-Recvd-Size: 6277
Received: from XPS-9350 (unknown [172.58.19.71])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Fri, 18 Sep 2020 19:07:48 +0000 (UTC)
Message-ID: <47b5bed0fc61fd9a4789816a5a836c7c3c2d41d2.camel@perches.com>
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
From:   Joe Perches <joe@perches.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        lee.jones@linaro.org, colin.king@canonical.com,
        mchehab+huawei@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date:   Fri, 18 Sep 2020 12:07:46 -0700
In-Reply-To: <2ce1124d-7f83-d9aa-f62a-519c8914ad98@kernel.dk>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
         <20200918145619.GA25599@embeddedor>
         <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
         <2ce1124d-7f83-d9aa-f62a-519c8914ad98@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-09-18 at 11:17 -0600, Jens Axboe wrote:
> On 9/18/20 11:13 AM, Joe Perches wrote:
> > On Fri, 2020-09-18 at 09:56 -0500, Gustavo A. R. Silva wrote:
> > > On Fri, Sep 18, 2020 at 05:32:30PM +0800, Jing Xiangfeng wrote:
> > > > Remove the superfluous break, as there is a 'return' before it.
> > > > 
> > > 
> > > Apparently, the change is correct. Please, just add a proper Fixes tag by
> > > yourself this time.
> > 
> > There's no need for a "Fixes:" here, it's purely cosmetic.
> > 
> > btw:
> > 
> > There are at least 150 instances of
> > 	return foo(...);
> > 	break;
> > still in the kernel tree:
> 
> A lot of these are false positives, since they follow a pattern of:
> 
> if (some_condition)
> 	return func();
> break;

Ah, right. Thanks.

Refining the test a bit to make sure the number of tabs before the
return and before the break are the same appears to show 42 instances.

$ grep-2.5.4 -rP --include=*.[ch] -n "^([\t]+)\breturn\s+\w+\s*\([^\)]+\)\s*;[ \t]*\n\1break\s*;\s*(case\s+\w+|default)\s*:" * | grep return | wc -l
42

(the line numbering seems screwed up below,
 but the instances listed seem right)

$ grep-2.5.4 -rP --include=*.[ch] -n "^([\t]+)\breturn\s+\w+\s*\([^\)]+\)\s*;[ \t]*\n\1break\s*;\s*(case\s+\w+|default)\s*:" * | grep return
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:275:		return pci_isa_read_bar(0);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:276:		return pci_isa_read_bar(1);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:277:		return pci_isa_read_bar(2);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:280:		return pci_isa_read_bar(4);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:281:		return pci_isa_read_bar(5);
arch/x86/kvm/emulate.c:1863:		return segmented_write(ctxt,
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2091:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2092:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2114:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/marvell/mwifiex/cfg80211.c:1210:			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
drivers/net/wireless/marvell/mwifiex/cfg80211.c:1246:			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:1200:		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
drivers/net/hyperv/netvsc.c:1275:		return netvsc_receive(ndev, net_device, nvchan,
drivers/media/dvb-frontends/si21xx.c:466:		return si21_writereg(state, LNB_CTRL_REG_1, val | 0x40);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1104:		return ttusb_dec_start_ts_feed(dvbdmxfeed);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1105:		return ttusb_dec_start_sec_feed(dvbdmxfeed);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1153:		return ttusb_dec_stop_ts_feed(dvbdmxfeed);
drivers/scsi/bfa/bfa_ioc.h:1000:		return bfi_image_cb_get_chunk(off);
drivers/scsi/bfa/bfa_ioc.h:1001:		return bfi_image_ct_get_chunk(off);
drivers/scsi/bfa/bfa_ioc.h:1002:		return bfi_image_ct2_get_chunk(off);
drivers/scsi/be2iscsi/be_mgmt.c:1245:		return snprintf(buf, PAGE_SIZE,
drivers/scsi/be2iscsi/be_mgmt.c:1247:		return snprintf(buf, PAGE_SIZE, "BE3-R Adapter Family\n");
drivers/scsi/be2iscsi/be_mgmt.c:1248:		return snprintf(buf, PAGE_SIZE, "Skyhawk-R Adapter Family\n");
drivers/scsi/arcmsr/arcmsr_hba.c:2701:		return arcmsr_hbaA_handle_isr(acb);
drivers/scsi/arcmsr/arcmsr_hba.c:2702:		return arcmsr_hbaB_handle_isr(acb);
drivers/iio/adc/meson_saradc.c:594:		return meson_sar_adc_get_sample(indio_dev, chan, NO_AVERAGING,
drivers/iio/adc/meson_saradc.c:595:		return meson_sar_adc_get_sample(indio_dev, chan,
drivers/s390/char/tape_34xx.c:653:					return tape_34xx_done(request);
drivers/s390/char/tape_3590.c:945:		return tape_3590_erp_failed(device, request, irb, -EIO);
drivers/nfc/st21nfca/core.c:792:		return nfc_hci_send_cmd_async(hdev, target->hci_reader_gate,
drivers/gpu/drm/mgag200/mgag200_mode.c:796:		return mga_g200se_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:798:		return mga_g200wb_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:799:		return mga_g200ev_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:801:		return mga_g200eh_set_plls(mdev, clock);
sound/soc/intel/skylake/skl-pcm.c:504:		return skl_run_pipe(skl, mconfig->pipe);
sound/oss/dmasound/dmasound_core.c:1005:		return IOCTL_OUT(arg, fmt);
sound/oss/dmasound/dmasound_core.c:1020:		return IOCTL_OUT(arg, size);
sound/oss/dmasound/dmasound_core.c:1121:		return IOCTL_OUT(arg, data);
tools/perf/ui/stdio/hist.c:392:		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
tools/perf/ui/stdio/hist.c:393:		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
tools/perf/ui/stdio/hist.c:394:		return callchain__fprintf_flat(fp, &he->sorted_chain, total_samples);
tools/perf/ui/stdio/hist.c:395:		return callchain__fprintf_folded(fp, &he->sorted_chain, total_samples);



