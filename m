Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE26C38145
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 07:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbiIFHlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 03:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbiIFHlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 03:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753FB25EA1
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 00:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F79A6135E
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFB2CC43470
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662450041;
        bh=BcXurSOjIJU1AGDWi+Pbv+hDmQvpzM2xpLhyOHMnMWk=;
        h=From:To:Subject:Date:From;
        b=VTXMQZ2EJBJpFn2CDFVzvtNwPnD+QvKPXnH+KJy+TLw++Hk80xkbFQfFtC11LGg+P
         HxbKETP4lzvIJm/Ur1kJCFwx47UvM2hAoibMxDfXqdeBcDvrqFBD0KqBUTiss0OjVn
         SKgJ3P7skPu9yOBCSQjfZ8Wy05riyHfGDMCfggLCkxINFzi0JJ+fc72lkm7oxkN5VX
         y2eCbq7KCm9DTuTqnNw0Dqw6jhio/a0ZRvsvhNZ2GY+WP9onWR2udXTzjPtoo48JJz
         YnB2B2+njzXCjbe9euqEyP+VE5FsSEWLg/FNJsQnw+s4PZ6DfD/04/ZWq9AgyQ+oOw
         9L7Jv7H/4ToVA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 93BE8C433E7; Tue,  6 Sep 2022 07:40:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216453] New: scsi: megaraid_sas: possible null pointer
 dereference in megasas_slave_alloc()
Date:   Tue, 06 Sep 2022 07:40:41 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: r33s3n6@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216453-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216453

            Bug ID: 216453
           Summary: scsi: megaraid_sas: possible null pointer dereference
                    in megasas_slave_alloc()
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.10.0
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: r33s3n6@gmail.com
        Regression: No

Hello,

Our fault injection tool finds a possible null-pointer dereference in the
megaraid_sas driver in Linux 5.10.0:

In the file drivers/scsi/megaraid/megaraid_sas_base.c:
In megasas_get_seq_num(), the call to dma_alloc_coherent() may fail:=20
6459: el_info =3D dma_alloc_coherent(&instance->pdev->dev,
                                   sizeof(struct megasas_evt_log_info),
                                   &el_info_h,
                                   GFP_KERNEL);

This error is propagated to its caller megasas_start_aen().
6749: if (megasas_get_seq_num(instance, &eli))
6750:     return -1;

Then it is propagated again to its caller megasas_probe_one().
7428: if (megasas_start_aen(instance)) {
7429:     dev_printk(KERN_DEBUG, &pdev->dev, "start aen failed\n");
7430:     goto fail_start_aen;
7431: }

In error handling code of megasas_probe_one(), it removes the pointer
`instance` from `megasas_mgmt_info.instance`:
7445: megasas_mgmt_info.instance[megasas_mgmt_info.max_index] =3D NULL;

But it stores the pointer `instance` in the pdev by calling pci_set_drvdata=
()
before and do nothing about it in error handling code:
7401: pci_set_drvdata(pdev, instance);

Then, in another thread, megasas_slave_alloc() is called. This function cal=
ls
megasas_lookup_instance() to get the pointer `instance`, which can not be
found in `megasas_mgmt_info.instance`. Therefore, NULL is returned:
2087: instance =3D megasas_lookup_instance(sdev->host->host_no);

This causes a null-pointer dereference bug:
2095: if ((instance->pd_list_not_supported ||=20
           instance->pd_list[pd_index].driveState =3D=3D MR_PD_STATE_SYSTEM=
))

If we just add a check for `instance`, another bug is found.
megasas_fault_detect_work() is called by a thread. and it retrieves the
pointer `instance` from `work`:
In the file drivers/scsi/megaraid/megaraid_sas_base.c:
1901: struct megasas_instance *instance =3D=20
        container_of(work, struct megasas_instance, fw_fault_work.work);

Because the structure `instance` points to is broken, the following calls
about `instance` causes some page-faults:
1907: fw_state =3D instance->instancet->read_fw_status_reg(instance) &
                 MFI_STATE_MASK;
1911: dma_state =3D instance->instancet->read_fw_status_reg(instance) &
                  MFI_STATE_DMADONE;
...

I am not quite sure how to fix this possible bug. Any feedback would be
appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Zixuan Fu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
