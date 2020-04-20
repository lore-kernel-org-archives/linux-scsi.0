Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7B9C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 09:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0211420A8B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 09:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5jlhDVz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgDTJl3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 05:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTJl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 05:41:29 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5791CC061A0F
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 02:41:29 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id m18so7504349otq.9
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=cQRn+7FPDu20L4lJ9Kd3lEXIPLuvlxgYNyGty+ESF9Q=;
        b=P5jlhDVzDwCTIwhpXqS60O6tlIQTTg/E+YZVhOTVGPkEZpisyKa6IXEr9r3cUZVRtC
         51yw4YXzEoz17VUJL51uY7FmMvjAmIcrlg57Gr+RBAtlLyacfcJqHULREnliCRRO/bXu
         O7m5jr57vgVVuPTWTDYVSTBQLABC4LpWkprHMFihnPUcqHZAIxaYrBnesdmgdYH6SPsR
         KFwQtq6kmFH6PPcR5wDeVEXkf8nQ61NattISRmHOipyIGFolk4/8ROqB9ItkX920CLk5
         5shaYIURazbWTQGtCZa6TAKAdU1cBT78AJs2caWYUXNOouqe5p/ppan/4Rh0CtJliKjG
         wsog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=cQRn+7FPDu20L4lJ9Kd3lEXIPLuvlxgYNyGty+ESF9Q=;
        b=D34IhyFuPbXBMEyWPxYHogIGMt3mepflFa1GuE7k9hyZ/hn9otmntkUR87ecAhfeWi
         Q9ZVT2imJR0QIVnIxicNFBv0MEpZHzyedFBmdwZvLJnftVEeoRxmCoYvXOfdmT8sK5oJ
         8lYKYO63h0Ozl0VB60aU9pnv7sgUh4/uA7lJ2OwHde3Dy95tydC4EgzS4Ycw64xaKLWi
         3LXytgekkMr0IMrpyo/ovH6fEc1qtEHgg+Esjr9Y6QNqKTAk4LRntOJ8ZBH1DlY789Xf
         thVu3aMFf2+Lunzm/BW/9YvH3zzwD9sJkWh1Zv0JUOy1zLcfnucpkN1UT4JDK6PuAtzx
         XHkA==
X-Gm-Message-State: AGi0Puaw1XyWnjqTxHTijG0p9poso108ajJEekY2QPtYFHQhRnXM+NmA
        4x8d2wlziYGbC0+VFtaKvZY+zPk04NQ31cmVg/0=
X-Google-Smtp-Source: APiQypKJuaIbInKKNyhL4+7NcZUvcGypLPyT0oQGPH12AXos4Ra9+vcRkvMjPXFLcwPjlvIZXlXpvX/CtCXmpqOzGdI=
X-Received: by 2002:a05:6830:3150:: with SMTP id c16mr8332426ots.251.1587375688780;
 Mon, 20 Apr 2020 02:41:28 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?5Lq/5LiA?= <teroincn@gmail.com>
Date:   Mon, 20 Apr 2020 17:41:17 +0800
Message-ID: <CANTwqXCarqAyA=DDbr2ORgBdgry_8OEgfOM+E8znzxWE2WPxsQ@mail.gmail.com>
Subject: [BUG] drivers: target: does there exist a memleak in function core_scsi3_emulate_pro_register_and_move
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, all:
When reviewing the code of function
core_scsi3_emulate_pro_register_and_move, the object dest_se_tpg
refcnt increased by atomic_inc_mb (&dest_se_tpg->tpg_pr_ref_count);
however if buf allocated by transport_kmap_data_sg is failed, we goto
out_put_pr_reg without release the reference of dest_se_tpg, it leak
reference of dest_se_tpg.

static sense_reason_t
core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
u64 sa_res_key, int aptpl, int unreg)
{
      list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {

            dest_se_tpg = tmp_lun->lun_tpg;
            dest_tf_ops = dest_se_tpg->se_tpg_tfo;
            if (!dest_tf_ops)
                  continue;

            atomic_inc_mb(&dest_se_tpg->tpg_pr_ref_count);
            spin_unlock(&dev->se_port_lock);

            if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
                  .....
                 atomic_dec_mb(&dest_se_tpg->tpg_pr_ref_count);
                 .....
                goto out_put_pr_reg;
             }

            spin_lock(&dev->se_port_lock);
            break;
      }
     spin_unlock(&dev->se_port_lock);

      if (!dest_se_tpg || !dest_tf_ops) {
           ......
           goto out_put_pr_reg;
      }

      buf = transport_kmap_data_sg(cmd);
      if (!buf) {
            ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
           goto out_put_pr_reg;
      }

      out_put_pr_reg:
            core_scsi3_put_pr_reg(pr_reg);
            return ret;
      }
