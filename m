Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD83BC43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 17:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98557206A2
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 17:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgIRRUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 13:20:52 -0400
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:57586 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726126AbgIRRUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 13:20:52 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 13:20:51 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 02F2618016BEF;
        Fri, 18 Sep 2020 17:14:01 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2F30C18016BF0;
        Fri, 18 Sep 2020 17:13:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: truck79_5d09a152712c
X-Filterd-Recvd-Size: 14230
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Fri, 18 Sep 2020 17:13:57 +0000 (UTC)
Message-ID: <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        lee.jones@linaro.org, colin.king@canonical.com, axboe@kernel.dk,
        mchehab+huawei@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date:   Fri, 18 Sep 2020 10:13:55 -0700
In-Reply-To: <20200918145619.GA25599@embeddedor>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
         <20200918145619.GA25599@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-09-18 at 09:56 -0500, Gustavo A. R. Silva wrote:
> On Fri, Sep 18, 2020 at 05:32:30PM +0800, Jing Xiangfeng wrote:
> > Remove the superfluous break, as there is a 'return' before it.
> > 
> 
> Apparently, the change is correct. Please, just add a proper Fixes tag by
> yourself this time.

There's no need for a "Fixes:" here, it's purely cosmetic.

btw:

There are at least 150 instances of
	return foo(...);
	break;
still in the kernel tree:

$ grep-2.5.4 --include=*.[ch] -rP -n "\breturn\s+\w+\s*\([^\)]+\)\s*;\s*break\s*;" * | grep return
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:275:		return pci_isa_read_bar(0);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:277:		return pci_isa_read_bar(1);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:279:		return pci_isa_read_bar(2);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:283:		return pci_isa_read_bar(4);
arch/mips/loongson2ef/common/cs5536/cs5536_isa.c:285:		return pci_isa_read_bar(5);
arch/sparc/kernel/viohs.c:334:			return handshake_failure(vio);
arch/sparc/kernel/perf_event.c:1442:			return PTR_ERR(pmap);
arch/x86/kvm/emulate.c:1857:			return segmented_write(ctxt,
arch/x86/kvm/emulate.c:1859:		return segmented_write(ctxt,
arch/x86/kvm/emulate.c:2922:			return emulate_gp(ctxt, 0);
arch/x86/kvm/emulate.c:4232:			return emulate_gp(ctxt, 0);
arch/x86/kvm/emulate.c:4255:			return emulate_gp(ctxt, 0);
arch/x86/kvm/emulate.c:4261:			return emulate_gp(ctxt, 0);
arch/x86/kernel/kgdb.c:535:				return single_step_cont(regs, args);
arch/x86/kernel/cpu/bugs.c:1676:			return l1tf_show_state(buf);
arch/x86/kernel/paravirt_patch.c:96:			return PATCH(lock, queued_spin_unlock, insn_buff, len);
arch/x86/kernel/paravirt_patch.c:100:			return PATCH(lock, vcpu_is_preempted, insn_buff, len);
arch/arm/nwfpe/fpa11_cprt.c:37:		return PerformFLT(opcode);
arch/arm/nwfpe/fpa11_cprt.c:39:		return PerformFIX(opcode);
arch/powerpc/kvm/book3s_pr_papr.c:394:			return kvmppc_h_pr_xics_hcall(vcpu, cmd);
block/blk-merge.c:1000:			return bio_attempt_back_merge(rq, bio, nr_segs);
block/blk-merge.c:1003:			return bio_attempt_front_merge(rq, bio, nr_segs);
drivers/net/macvtap.c:180:			return notifier_from_errno(err);
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2091:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2093:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2116:		return __rtl8821ae_phy_config_with_headerfile(hw,
drivers/net/wireless/marvell/mwifiex/uap_event.c:246:			return mwifiex_handle_event_ext_scan_report(priv,
drivers/net/wireless/marvell/mwifiex/cfg80211.c:1210:			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
drivers/net/wireless/marvell/mwifiex/cfg80211.c:1247:			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
drivers/net/wireless/ath/ath10k/htt_rx.c:3878:		return ath10k_htt_rx_proc_rx_frag_ind(htt,
drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:1200:		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:1205:			return iwl_mvm_mac_ctxt_cmd_go(mvm, vif, action);
drivers/net/ipvlan/ipvtap.c:173:			return notifier_from_errno(err);
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4837:			return mvpp2_set_ts_config(port, ifr);
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4841:			return mvpp2_get_ts_config(port, ifr);
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3624:			return cxgb4_tc_matchall_stats(dev, cls_matchall);
drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:1792:			return mlxsw_sp_netdevice_ipip_ul_vrf_event(mlxsw_sp,
drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:6831:			return PTR_ERR(rif);
drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h:74:			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_128);
drivers/net/wan/lmc/lmc_proto.c:103:	    return hdlc_type_trans(skb, sc->lmc_device);
drivers/net/wan/lmc/lmc_proto.c:105:        return htons(ETH_P_802_2);
drivers/net/wan/lmc/lmc_proto.c:107:        return htons(ETH_P_802_2);
drivers/net/wan/lmc/lmc_proto.c:110:        return htons(ETH_P_802_2);
drivers/net/hyperv/netvsc.c:1275:		return netvsc_receive(ndev, net_device, nvchan,
drivers/target/iscsi/iscsi_target.c:2098:			return iscsit_add_reject_cmd(cmd,
drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:527:				return PTR_ERR(ctx->hashalg);
drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:533:				return PTR_ERR(ctx->hashalg);
drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:539:				return PTR_ERR(ctx->hashalg);
drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:545:				return PTR_ERR(ctx->hashalg);
drivers/mfd/da9052-i2c.c:69:			return regmap_read(da9052->regmap,
drivers/staging/vme/devices/vme_user.c:357:			return vme_master_set(image[minor].resource,
drivers/staging/vme/devices/vme_user.c:393:			return vme_slave_set(image[minor].resource,
drivers/staging/iio/addac/adt7316.c:1158:			return sprintf(buf, "%d\n", data);
drivers/staging/comedi/drivers/ni_mio_common.c:5571:			return NISTC_ATRIG_ETC_GPFO_0_SEL_TO_SRC(reg);
drivers/staging/comedi/drivers/ni_mio_common.c:5574:			return NISTC_ATRIG_ETC_GPFO_1_SEL_TO_SRC(reg);
drivers/firmware/google/vpd_decode.c:89:			return callback(key, key_len, value, value_len,
drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c:1105:			return solo_set_motion_block(solo_dev, solo_enc->ch,
drivers/media/dvb-frontends/si21xx.c:466:		return si21_writereg(state, LNB_CTRL_REG_1, val | 0x40);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1104:		return ttusb_dec_start_ts_feed(dvbdmxfeed);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1107:		return ttusb_dec_start_sec_feed(dvbdmxfeed);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1157:		return ttusb_dec_stop_ts_feed(dvbdmxfeed);
drivers/media/usb/ttusb-dec/ttusb_dec.c:1160:		return ttusb_dec_stop_sec_feed(dvbdmxfeed);
drivers/media/v4l2-core/v4l2-fwnode.c:1264:				return PTR_ERR(fwnode);
drivers/media/test-drivers/vivid/vivid-vid-out.c:1204:			return v4l2_src_change_event_subscribe(fh, sub);
drivers/media/cec/core/cec-adap.c:2078:			return cec_feature_abort(adap, msg);
drivers/scsi/bfa/bfa_ioc.h:1000:		return bfi_image_cb_get_chunk(off);
drivers/scsi/bfa/bfa_ioc.h:1002:		return bfi_image_ct_get_chunk(off);
drivers/scsi/bfa/bfa_ioc.h:1004:		return bfi_image_ct2_get_chunk(off);
drivers/scsi/be2iscsi/be_mgmt.c:1245:		return snprintf(buf, PAGE_SIZE,
drivers/scsi/be2iscsi/be_mgmt.c:1248:		return snprintf(buf, PAGE_SIZE, "BE3-R Adapter Family\n");
drivers/scsi/be2iscsi/be_mgmt.c:1250:		return snprintf(buf, PAGE_SIZE, "Skyhawk-R Adapter Family\n");
drivers/scsi/be2iscsi/be_mgmt.c:1252:		return snprintf(buf, PAGE_SIZE,
drivers/scsi/arcmsr/arcmsr_hba.c:2701:		return arcmsr_hbaA_handle_isr(acb);
drivers/scsi/arcmsr/arcmsr_hba.c:2703:		return arcmsr_hbaB_handle_isr(acb);
drivers/iio/adc/nau7802.c:370:				return nau7802_set_gain(st, i);
drivers/iio/adc/meson_saradc.c:594:		return meson_sar_adc_get_sample(indio_dev, chan, NO_AVERAGING,
drivers/iio/adc/meson_saradc.c:597:		return meson_sar_adc_get_sample(indio_dev, chan,
drivers/infiniband/hw/mlx5/fs.c:2235:			return MLX5_CAP_FLOWTABLE(ibdev->mdev,
drivers/infiniband/hw/mlx5/fs.c:2238:			return MLX5_CAP_FLOWTABLE_NIC_TX(ibdev->mdev,
drivers/infiniband/hw/mlx5/fs.c:2241:			return MLX5_CAP_FLOWTABLE_NIC_RX(ibdev->mdev,
drivers/infiniband/hw/mlx5/fs.c:2244:			return MLX5_CAP_FLOWTABLE_NIC_RX(ibdev->mdev, decap);
drivers/char/ipmi/ipmi_devintf.c:492:		return ipmi_set_my_address(priv->user, val.channel, val.value);
drivers/s390/scsi/zfcp_erp.c:1096:			return zfcp_erp_port_strategy_close(erp_action);
drivers/s390/char/tape_34xx.c:653:					return tape_34xx_done(request);
drivers/s390/char/tape_3590.c:945:		return tape_3590_erp_failed(device, request, irb, -EIO);
drivers/nfc/st21nfca/core.c:792:		return nfc_hci_send_cmd_async(hdev, target->hci_reader_gate,
drivers/gpu/drm/mgag200/mgag200_mode.c:796:		return mga_g200se_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:799:		return mga_g200wb_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:801:		return mga_g200ev_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:804:		return mga_g200eh_set_plls(mdev, clock);
drivers/gpu/drm/mgag200/mgag200_mode.c:806:		return mga_g200er_set_plls(mdev, clock);
drivers/gpu/drm/i915/display/intel_display.c:12599:				return PTR_ERR(linked_state);
drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c:321:			return ERR_PTR(r);
drivers/gpu/drm/amd/display/dc/bios/bios_parser.c:953:				return get_ss_info_from_tbl(bp, clk_id_ss,
drivers/gpu/drm/gma500/mdfld_dsi_output.c:451:			return PTR_ERR(gpiod);
drivers/gpu/drm/gma500/mdfld_dsi_output.c:455:			return PTR_ERR(gpiod);
drivers/gpu/drm/bridge/tc358767.c:405:			return tc_aux_read_data(tc, msg->buffer, size);
drivers/tty/vt/vt_ioctl.c:1002:			return vt_disallocate(--arg);
drivers/tty/tty_io.c:1868:			return ERR_PTR(-ENODEV);
drivers/platform/x86/acer-wmi.c:794:			return ec_write(0x83, value);
drivers/mtd/mtdchar.c:883:		return mtd_block_isbad(mtd, offs);
drivers/mtd/mtdchar.c:892:		return mtd_block_markbad(mtd, offs);
drivers/tee/optee/supp.c:251:				return PTR_ERR(req);
drivers/acpi/acpi_lpss.c:1292:			return sysfs_create_group(&pdev->dev.kobj,
drivers/hid/hid-lg-g15.c:616:			return lg_g15_event(g15, data, size);
drivers/hid/hid-lg-g15.c:619:			return lg_g15_v2_event(g15, data, size);
drivers/hid/hid-lg-g15.c:625:			return lg_g510_leds_event(g15, data, size);
drivers/ata/libata-sff.c:1477:			return ata_sff_idle_irq(ap);
fs/ubifs/find.c:923:			return PTR_ERR(lp);
fs/nfsd/nfs4state.c:5724:			return find_writeable_file(s->sc_file);
fs/ioctl.c:732:			return file_ioctl(filp, cmd, argp);
include/net/netfilter/nf_queue.h:92:			return hash_v4(iph, initval);
include/net/netfilter/nf_queue.h:97:			return hash_v6(ip6h, initval);
kernel/exit.c:1519:			return PTR_ERR(pid);
lib/test_objagg.c:777:			return PTR_ERR(objagg_obj);
net/wireless/core.c:1439:			return notifier_from_errno(-ERFKILL);
net/wireless/util.c:86:			return MHZ_TO_KHZ(2407 + chan * 5);
net/wireless/util.c:91:			return MHZ_TO_KHZ(5000 + chan * 5);
net/wireless/util.c:97:			return MHZ_TO_KHZ(5950 + chan * 5);
net/wireless/util.c:100:			return MHZ_TO_KHZ(56160 + chan * 2160);
net/wireless/chan.c:496:			return BIT(chandef->width);
net/wireless/nl80211.c:6363:			return PTR_ERR(params.vlan);
net/netlabel/netlabel_kapi.c:1444:			return cipso_v4_cache_add(ptr, secattr);
net/netlabel/netlabel_kapi.c:1449:			return calipso_cache_add(ptr, secattr);
net/8021q/vlan.c:510:			return notifier_from_errno(err);
net/8021q/vlan.c:519:			return notifier_from_errno(err);
net/ipv4/ipmr.c:844:			return PTR_ERR(dev);
net/bridge/br.c:71:			return notifier_from_errno(err);
net/bridge/br.c:117:			return notifier_from_errno(err);
net/xfrm/xfrm_output.c:384:			return xfrm6_prepare_output(x, skb);
net/xfrm/xfrm_output.c:389:			return xfrm6_transport_output(x, skb);
net/xfrm/xfrm_input.c:341:			return xfrm6_remove_beet_encap(x, skb);
net/xfrm/xfrm_input.c:346:			return xfrm6_remove_tunnel_encap(x, skb);
net/xfrm/xfrm_input.c:444:			return xfrm6_transport_input(x, skb);
net/packet/af_packet.c:3529:			return dev_mc_del(dev, i->addr);
net/packet/af_packet.c:3540:			return dev_uc_del(dev, i->addr);
net/sunrpc/clnt.c:191:			return PTR_ERR(dentry);
sound/soc/intel/skylake/skl-pcm.c:504:		return skl_run_pipe(skl, mconfig->pipe);
sound/oss/dmasound/dmasound_core.c:1005:		return IOCTL_OUT(arg, fmt);
sound/oss/dmasound/dmasound_core.c:1021:		return IOCTL_OUT(arg, size);
sound/oss/dmasound/dmasound_core.c:1123:		return IOCTL_OUT(arg, data);
sound/aoa/soundbus/i2sbus/control.c:119:			return pmf_call_one(i2sdev->cell_disable, &args);
sound/aoa/soundbus/i2sbus/control.c:122:			return pmf_call_one(i2sdev->cell_enable, &args);
sound/aoa/soundbus/i2sbus/control.c:160:			return pmf_call_one(i2sdev->clock_disable, &args);
sound/aoa/soundbus/i2sbus/control.c:163:			return pmf_call_one(i2sdev->clock_enable, &args);
sound/usb/quirks.c:1372:			return snd_usb_motu_microbookii_boot_quirk(dev);
sound/core/seq/oss/seq_oss_event.c:72:			return snd_seq_oss_midi_putc(dp, q->s.dev, q->s.parm1, ev);
tools/perf/util/sort.c:2168:				return scnprintf(hpp->buf, hpp->size,
tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c:547:			return intel_pt_get_bip_4(buf, len, packet);
tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c:550:			return intel_pt_get_bip_8(buf, len, packet);
tools/perf/util/evsel.c:2536:			return scnprintf(msg, size, "%s",
tools/perf/util/evsel.c:2569:			return scnprintf(msg, size, "The 'aux_output' feature is not supported, update the kernel.");
tools/perf/ui/stdio/hist.c:392:		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
tools/perf/ui/stdio/hist.c:394:		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
tools/perf/ui/stdio/hist.c:396:		return callchain__fprintf_flat(fp, &he->sorted_chain, total_samples);
tools/perf/ui/stdio/hist.c:398:		return callchain__fprintf_folded(fp, &he->sorted_chain, total_samples);



