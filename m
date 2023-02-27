Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084FDC64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 06:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjB0GRR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 01:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0GRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 01:17:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC431ACC1
        for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2023 22:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677478588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=kXft4ktL2TjV4oN52cC2tle35EiHT36ffVcOndFcJfs=;
        b=AVypY1DyuXnLhiKfqN5gs2ob8RVkuvvf59hQfrrw7GJERpvmyzBUguXb4xZc4XHWlqfUMO
        SZwYcYejKMv2JncUVjXR3LEK9NG31l75jHCt64NKH+KP7HcKVzQgaF286QTxZH6BQc3V/G
        U6Ser4DWW3f+IcQX9XVLctqu8Thg/Yo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-5aj5ZsqxMOmcwXSLoFZ94w-1; Mon, 27 Feb 2023 01:16:26 -0500
X-MC-Unique: 5aj5ZsqxMOmcwXSLoFZ94w-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-536bbaeceeaso118913587b3.11
        for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2023 22:16:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kXft4ktL2TjV4oN52cC2tle35EiHT36ffVcOndFcJfs=;
        b=n999Pc43qlq8fCrYuwNz10IvksCWForfbN5060RW8y9S2esQZDNm2NusC4j/dCv6ZV
         8OBBLekVdKohla93KLz4pHdG/OCsEHUziUNHCzh6TQTOI6HNw5OzH8bJQtsF9UCd4Kje
         b9yo6eIKFH1l4r975748Ar50EYIhUe13jVCs4lWeuOjRTEqz+oRJjuIT/MngHkS1ShC2
         IWH41XiqcY4LW49JPJxwVSsZolVl0QNFyGIpc3+CZaixoJo+wRj+TuHWZbfsUakhu/Zz
         a+OzRurU/468J3tjmtp2XbBxOQzVwjUxPJfPMSoYkI//1So6HI99EpfT2COdjgeZxZgw
         Lj4Q==
X-Gm-Message-State: AO0yUKXxvraXsfzZMuuuo3VSpojKd9akSScXukJztObJm/RaYoCryQQF
        UDV+P4ooF3nY6P1oq7jQvUqh8zT6UrxExmpDjzG0lJXWUN0PW0cQcJ0/gLe1wng2r9q7runiC2U
        Khf7k9NlFXw+YiTvctPtUyGT1bQqBSDj64jMinxFYYjupwHZS1Z0=
X-Received: by 2002:a05:6902:38c:b0:a60:c167:c053 with SMTP id f12-20020a056902038c00b00a60c167c053mr3881164ybs.11.1677478585797;
        Sun, 26 Feb 2023 22:16:25 -0800 (PST)
X-Google-Smtp-Source: AK7set/ENojCVX3EJqKiS1B3ZyAsqoyhQvqbIX2B9v27o6IdUfuKCjsY5Es852N2iKWk++YE/9wwnqxwJMeVi0BSoCA=
X-Received: by 2002:a05:6902:38c:b0:a60:c167:c053 with SMTP id
 f12-20020a056902038c00b00a60c167c053mr3881152ybs.11.1677478585424; Sun, 26
 Feb 2023 22:16:25 -0800 (PST)
MIME-Version: 1.0
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Mon, 27 Feb 2023 14:17:11 +0800
Message-ID: <CAGS2=YoBAjhGCi=007s2NsPvHb5v4=r=5cFm3BbogD6+6g8ZcQ@mail.gmail.com>
Subject: [bug report] BUG: KASAN: use-after-free in fcoe_ctlr_encaps+0xb2c/0xd60
 [libfcoe]
To:     linux-scsi@vger.kernel.org, John Meneghini <jmeneghi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Found kernel issue when create/remove npiv port with qedf driver,

kernel repo : https://github.com/torvalds/linux.git
kernel : 6.2.0.kasan



[  190.028419] [0000:41:00.2]:[qedf_vport_create:1850]:8: Creating
NPIV port, WWPN=2000000000000001.
[  200.222789] [0000:41:00.3]:[qedf_vport_create:1850]:9: Creating
NPIV port, WWPN=2000000000000002.
[  235.060919] ==================================================================
[  235.068985] BUG: KASAN: use-after-free in
fcoe_ctlr_encaps+0xb2c/0xd60 [libfcoe]
[  235.077297] Read of size 2 at addr ffff888142bc456c by task kworker/0:3/125
[  235.085075]
[  235.086743] CPU: 0 PID: 125 Comm: kworker/0:3 Kdump: loaded Not
tainted 6.2.0.kasan+ #1
[  235.095686] Hardware name: Dell Inc. PowerEdge R420/072XWF, BIOS
2.9.0 01/09/2020
[  235.104049] Workqueue: fc_wq_9 fc_vport_sched_delete [scsi_transport_fc]
[  235.111585] Call Trace:
[  235.114319]  <TASK>
[  235.116663]  dump_stack_lvl+0x33/0x50
[  235.120772]  print_address_description.constprop.0+0x28/0x380
[  235.127203]  print_report+0xb5/0x270
[  235.131193]  ? kasan_addr_to_slab+0x9/0xa0
[  235.135773]  ? fcoe_ctlr_encaps+0xb2c/0xd60 [libfcoe]
[  235.141459]  kasan_report+0xcf/0x100
[  235.145464]  ? fcoe_ctlr_encaps+0xb2c/0xd60 [libfcoe]
[  235.151144]  fcoe_ctlr_encaps+0xb2c/0xd60 [libfcoe]
[  235.156634]  fcoe_ctlr_els_send+0x24b/0x1240 [libfcoe]
[  235.162417]  ? ___slab_alloc+0x703/0x7a0
[  235.166817]  qedf_xmit+0x16e9/0x21c0 [qedf]
[  235.171531]  fc_exch_seq_send+0x5ba/0xe70 [libfc]
[  235.176854]  ? __pfx_fc_lport_logo_resp+0x10/0x10 [libfc]
[  235.182956]  fc_elsct_send+0xd4e/0x2b40 [libfc]
[  235.188081]  ? __alloc_skb+0x1ee/0x270
[  235.192276]  ? __pfx_fc_elsct_send+0x10/0x10 [libfc]
[  235.197885]  ? __pfx_qedf_elsct_send+0x10/0x10 [qedf]
[  235.203549]  fc_lport_enter_logo+0x153/0x320 [libfc]
[  235.209158]  fc_fabric_logoff+0x90/0xc0 [libfc]
[  235.214280]  qedf_vport_destroy+0x19f/0x360 [qedf]
[  235.219663]  fc_vport_terminate+0xf6/0x5a0 [scsi_transport_fc]
[  235.226217]  ? _raw_spin_lock_irq+0x82/0xe0
[  235.230905]  fc_vport_sched_delete+0x1e/0x1d0 [scsi_transport_fc]
[  235.237743]  process_one_work+0x680/0x10f0
[  235.242318]  worker_thread+0x571/0xe70
[  235.246513]  ? __kthread_parkme+0x83/0x140
[  235.251095]  ? __pfx_worker_thread+0x10/0x10
[  235.255870]  kthread+0x25d/0x2f0
[  235.259483]  ? __pfx_kthread+0x10/0x10
[  235.263677]  ret_from_fork+0x2c/0x50
[  235.267683]  </TASK>
[  235.270125]
[  235.271789] Allocated by task 290:
[  235.275590]  kasan_save_stack+0x1e/0x40
[  235.279884]  kasan_set_track+0x21/0x30
[  235.284075]  __kasan_kmalloc+0xa9/0xb0
[  235.288265]  fcoe_ctlr_recv_adv+0x70a/0xf20 [libfcoe]
[  235.293947]  fcoe_ctlr_recv_handler.isra.0+0x4fd/0x8e0 [libfcoe]
[  235.300689]  fcoe_ctlr_recv_work+0x1c/0x40 [libfcoe]
[  235.306264]  process_one_work+0x680/0x10f0
[  235.310850]  worker_thread+0x571/0xe70
[  235.315038]  kthread+0x25d/0x2f0
[  235.318653]  ret_from_fork+0x2c/0x50
[  235.322656]
[  235.324326] Freed by task 2641:
[  235.327839]  kasan_save_stack+0x1e/0x40
[  235.332123]  kasan_set_track+0x21/0x30
[  235.336310]  kasan_save_free_info+0x2a/0x50
[  235.340987]  ____kasan_slab_free+0x169/0x1d0
[  235.345756]  slab_free_freelist_hook+0xcb/0x190
[  235.350819]  __kmem_cache_free+0x187/0x2c0
[  235.355395]  fcoe_ctlr_destroy+0xc6/0x1a0 [libfcoe]
[  235.360867]  __qedf_remove+0x41b/0x1520 [qedf]
[  235.365864]  pci_device_remove+0xa2/0x1d0
[  235.370349]  device_release_driver_internal+0x3bd/0x600
[  235.376199]  driver_detach+0xbb/0x170
[  235.380299]  bus_remove_driver+0xe4/0x2d0
[  235.384781]  pci_unregister_driver+0x26/0x250
[  235.389649]  qedf_cleanup+0xc/0x210 [qedf]
[  235.394254]  __do_sys_delete_module.constprop.0+0x2f1/0x530
[  235.400490]  do_syscall_64+0x5c/0x90
[  235.404490]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  235.410137]
[  235.411808] Last potentially related work creation:
[  235.417261]  kasan_save_stack+0x1e/0x40
[  235.421547]  __kasan_record_aux_stack+0xb6/0xd0
[  235.426609]  __call_rcu_common.constprop.0+0xc3/0x920
[  235.432263]  blk_put_queue+0xc7/0x200
[  235.436359]  scsi_device_dev_release+0x561/0xda0
[  235.441523]  device_release+0x9b/0x210
[  235.445720]  kobject_cleanup+0x104/0x360
[  235.450109]  scsi_alloc_sdev+0xa0a/0xc20
[  235.454501]  scsi_probe_and_add_lun+0x42d/0xb60
[  235.459563]  __scsi_scan_target+0x18e/0x3d0
[  235.464237]  scsi_scan_channel+0xf6/0x180
[  235.468723]  scsi_scan_host_selected+0x1fa/0x2e0
[  235.473885]  do_scan_async+0x3f/0x490
[  235.477979]  async_run_entry_fn+0x96/0x4f0
[  235.482563]  process_one_work+0x680/0x10f0
[  235.487145]  worker_thread+0x571/0xe70
[  235.491332]  kthread+0x25d/0x2f0
[  235.494939]  ret_from_fork+0x2c/0x50
[  235.498941]
[  235.500604] The buggy address belongs to the object at ffff888142bc4500
[  235.500604]  which belongs to the cache kmalloc-128 of size 128
[  235.514591] The buggy address is located 108 bytes inside of
[  235.514591]  128-byte region [ffff888142bc4500, ffff888142bc4580)
[  235.527699]
[  235.529362] The buggy address belongs to the physical page:
[  235.535596] page:ffffea00050af100 refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x142bc4
[  235.546090] head:ffffea00050af100 order:1 compound_mapcount:0
subpages_mapcount:0 compound_pincount:0
[  235.556387] flags:
0x57ffffc0010200(slab|head|node=1|zone=2|lastcpupid=0x1fffff)
[  235.564658] raw: 0057ffffc0010200 ffff88800104cc80 ffffea0005041a90
ffffea0005368990
[  235.573308] raw: 0000000000000000 0000000000150015 00000001ffffffff
0000000000000000
[  235.581957] page dumped because: kasan: bad access detected
[  235.588186]
[  235.589856] Memory state around the buggy address:
[  235.595214]  ffff888142bc4400: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  235.603280]  ffff888142bc4480: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  235.611347] >ffff888142bc4500: fa fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  235.619411]                                                           ^
[  235.626794]  ffff888142bc4580: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  235.634861]  ffff888142bc4600: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  235.642928] ==================================================================
[  235.651020] Disabling lock debugging due to kernel taint
[  235.656965] [0000:41:00.3]:[qedf_fip_send:159]:11: start_xmit
failed rc = -22.

--

