Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A474C28E86
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377C964F6B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCQJNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhCQJNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD6C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v4so992073wrp.13
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fNw4jZUecOl7ZFIahTA4vjB4JeA3UkCpE7Qa3MdiWdM=;
        b=bTxzXrxbu/7ViHtc9cONzNsgRMR25BL7okAd45pBJEnHuMsQe6n25d/I3qWaO87eXx
         WHvZ+yPWGmMQOY/Lv4OLel3rljYrzcoI0jZIAKWBC1XaVP6q7cQn8DrPJ4okm4RKVl1n
         uz2wnEzlRGeDrUg7KLakMYWwJyLvp34BvsWX92PQmjPFeyrnFYfVGN+TSzFoHVYwg0jH
         QhEi58nPo16CWZV+g3WOliU4WOvuykrCryu1UzFTjmq5Iks9FwWLnKsQd2DSWDjRWA8G
         wEimbpstuyftoW3oxVLGXqPlseaPdaxB6IV+GtcwmzBIRBjhs1BCT5g6fY2ckjB2xiHY
         CKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fNw4jZUecOl7ZFIahTA4vjB4JeA3UkCpE7Qa3MdiWdM=;
        b=Ar2b723GHwflTnj0O1Rutxo11PGIr6OuydMCl47NtGnRZ17/9iFq2TJg5xwf4HiMaw
         y2t4hIA+Uomv/1Hroff5pO5KFWpN7MSiVwS++xQb7N6DvE+QXem5p0sIC2rL2GnRm9jo
         khqDKQGcDxm4YrLlRcqFbSVnD0PrrTUljuY+5L95wJB6LDcVZx39fmj1cjGk+glh29BK
         WGPzwzdXCjluhlGNzvfLZs5lJXAN59XEADZbOSrFECBnY1UVPAywNuM5lU7M0B/oBbcH
         FtTbwzBjA0NIU+uFCE8nuhcArM7QpOLQ6L3MU5pM9DwL91mhqtcHhfWdtv4ehOir9AYP
         e4UA==
X-Gm-Message-State: AOAM530OARt7vdCAqSMNzEKP74yRwpS2RIciqsMosHtghzJQFDz1hUz1
        ciBu9ukrFv89jnN56XeHhFGdFw==
X-Google-Smtp-Source: ABdhPJyzSXX5mSSTB1uAcPOXjLN62qWJxkCRImHn+WLBeAjxwIaNseaHMJXrew6AGMi9n8+sBjhXQw==
X-Received: by 2002:adf:9544:: with SMTP id 62mr3295141wrs.128.1615972388614;
        Wed, 17 Mar 2021 02:13:08 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 28/36] scsi: isci: port: Fix a bunch of kernel-doc issues
Date:   Wed, 17 Mar 2021 09:12:22 +0000
Message-Id: <20210317091230.2912389-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/port.c:130: warning: Function parameter or member 'iport' not described in 'sci_port_get_properties'
 drivers/scsi/isci/port.c:130: warning: Function parameter or member 'prop' not described in 'sci_port_get_properties'
 drivers/scsi/isci/port.c:130: warning: Excess function parameter 'port' description in 'sci_port_get_properties'
 drivers/scsi/isci/port.c:130: warning: Excess function parameter 'properties' description in 'sci_port_get_properties'
 drivers/scsi/isci/port.c:243: warning: Function parameter or member 'isci_phy' not described in 'isci_port_link_down'
 drivers/scsi/isci/port.c:243: warning: Function parameter or member 'isci_port' not described in 'isci_port_link_down'
 drivers/scsi/isci/port.c:243: warning: Excess function parameter 'phy' description in 'isci_port_link_down'
 drivers/scsi/isci/port.c:243: warning: Excess function parameter 'port' description in 'isci_port_link_down'
 drivers/scsi/isci/port.c:318: warning: Function parameter or member 'isci_port' not described in 'isci_port_hard_reset_complete'
 drivers/scsi/isci/port.c:318: warning: Excess function parameter 'port' description in 'isci_port_hard_reset_complete'
 drivers/scsi/isci/port.c:398: warning: Cannot understand  *
 drivers/scsi/isci/port.c:544: warning: Function parameter or member 'iport' not described in 'sci_port_construct_dummy_rnc'
 drivers/scsi/isci/port.c:544: warning: Excess function parameter 'sci_port' description in 'sci_port_construct_dummy_rnc'
 drivers/scsi/isci/port.c:692: warning: Function parameter or member 'iport' not described in 'sci_port_general_link_up_handler'
 drivers/scsi/isci/port.c:692: warning: Function parameter or member 'iphy' not described in 'sci_port_general_link_up_handler'
 drivers/scsi/isci/port.c:692: warning: Excess function parameter 'sci_port' description in 'sci_port_general_link_up_handler'
 drivers/scsi/isci/port.c:692: warning: Excess function parameter 'sci_phy' description in 'sci_port_general_link_up_handler'
 drivers/scsi/isci/port.c:719: warning: wrong kernel-doc identifier on line:
 drivers/scsi/isci/port.c:756: warning: Function parameter or member 'iport' not described in 'sci_port_link_detected'
 drivers/scsi/isci/port.c:756: warning: Function parameter or member 'iphy' not described in 'sci_port_link_detected'
 drivers/scsi/isci/port.c:756: warning: expecting prototype for if the(). Prototype was for sci_port_link_detected() instead
 drivers/scsi/isci/port.c:821: warning: wrong kernel-doc identifier on line:
 drivers/scsi/isci/port.c:885: warning: Function parameter or member 'iport' not described in 'sci_port_post_dummy_request'
 drivers/scsi/isci/port.c:885: warning: Excess function parameter 'sci_port' description in 'sci_port_post_dummy_request'
 drivers/scsi/isci/port.c:909: warning: Function parameter or member 'iport' not described in 'sci_port_abort_dummy_request'
 drivers/scsi/isci/port.c:909: warning: expecting prototype for This will alow the hardware to(). Prototype was for sci_port_abort_dummy_request() instead
 drivers/scsi/isci/port.c:926: warning: Cannot understand  *
 drivers/scsi/isci/port.c:1017: warning: Cannot understand  *
 drivers/scsi/isci/port.c:1199: warning: Function parameter or member 'iport' not described in 'sci_port_add_phy'
 drivers/scsi/isci/port.c:1199: warning: Function parameter or member 'iphy' not described in 'sci_port_add_phy'
 drivers/scsi/isci/port.c:1199: warning: Excess function parameter 'sci_port' description in 'sci_port_add_phy'
 drivers/scsi/isci/port.c:1199: warning: Excess function parameter 'sci_phy' description in 'sci_port_add_phy'
 drivers/scsi/isci/port.c:1270: warning: Function parameter or member 'iport' not described in 'sci_port_remove_phy'
 drivers/scsi/isci/port.c:1270: warning: Function parameter or member 'iphy' not described in 'sci_port_remove_phy'
 drivers/scsi/isci/port.c:1270: warning: Excess function parameter 'sci_port' description in 'sci_port_remove_phy'
 drivers/scsi/isci/port.c:1270: warning: Excess function parameter 'sci_phy' description in 'sci_port_remove_phy'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/port.c | 58 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 5a362ba76d63f..d5f550d5a4824 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -115,9 +115,9 @@ static u32 sci_port_get_phys(struct isci_port *iport)
 /**
  * sci_port_get_properties() - This method simply returns the properties
  *    regarding the port, such as: physical index, protocols, sas address, etc.
- * @port: this parameter specifies the port for which to retrieve the physical
+ * @iport: this parameter specifies the port for which to retrieve the physical
  *    index.
- * @properties: This parameter specifies the properties structure into which to
+ * @prop: This parameter specifies the properties structure into which to
  *    copy the requested information.
  *
  * Indicate if the user specified a valid port. SCI_SUCCESS This value is
@@ -233,8 +233,8 @@ static void isci_port_link_up(struct isci_host *isci_host,
  * isci_port_link_down() - This function is called by the sci core when a link
  *    becomes inactive.
  * @isci_host: This parameter specifies the isci host object.
- * @phy: This parameter specifies the isci phy with the active link.
- * @port: This parameter specifies the isci port with the active link.
+ * @isci_phy: This parameter specifies the isci phy with the active link.
+ * @isci_port: This parameter specifies the isci port with the active link.
  *
  */
 static void isci_port_link_down(struct isci_host *isci_host,
@@ -308,7 +308,7 @@ static void port_state_machine_change(struct isci_port *iport,
 /**
  * isci_port_hard_reset_complete() - This function is called by the sci core
  *    when the hard reset complete notification has been received.
- * @port: This parameter specifies the sci port with the active link.
+ * @isci_port: This parameter specifies the sci port with the active link.
  * @completion_status: This parameter specifies the core status for the reset
  *    process.
  *
@@ -395,9 +395,10 @@ bool sci_port_is_valid_phy_assignment(struct isci_port *iport, u32 phy_index)
 }
 
 /**
- *
- * @sci_port: This is the port object for which to determine if the phy mask
+ * sci_port_is_phy_mask_valid()
+ * @iport: This is the port object for which to determine if the phy mask
  *    can be supported.
+ * @phy_mask: Phy mask belonging to this port
  *
  * This method will return a true value if the port's phy mask can be supported
  * by the SCU. The following is a list of valid PHY mask configurations for
@@ -533,7 +534,7 @@ void sci_port_get_attached_sas_address(struct isci_port *iport, struct sci_sas_a
 /**
  * sci_port_construct_dummy_rnc() - create dummy rnc for si workaround
  *
- * @sci_port: logical port on which we need to create the remote node context
+ * @iport: logical port on which we need to create the remote node context
  * @rni: remote node index for this remote node context.
  *
  * This routine will construct a dummy remote node context data structure
@@ -677,8 +678,8 @@ static void sci_port_invalid_link_up(struct isci_port *iport, struct isci_phy *i
 
 /**
  * sci_port_general_link_up_handler - phy can be assigned to port?
- * @sci_port: sci_port object for which has a phy that has gone link up.
- * @sci_phy: This is the struct isci_phy object that has gone link up.
+ * @iport: sci_port object for which has a phy that has gone link up.
+ * @iphy: This is the struct isci_phy object that has gone link up.
  * @flags: PF_RESUME, PF_NOTIFY to sci_port_activate_phy
  *
  * Determine if this phy can be assigned to this port . If the phy is
@@ -716,10 +717,11 @@ static void sci_port_general_link_up_handler(struct isci_port *iport,
 
 
 /**
+ * sci_port_is_wide()
  * This method returns false if the port only has a single phy object assigned.
  *     If there are no phys or more than one phy then the method will return
  *    true.
- * @sci_port: The port for which the wide port condition is to be checked.
+ * @iport: The port for which the wide port condition is to be checked.
  *
  * bool true Is returned if this is a wide ported port. false Is returned if
  * this is a narrow port.
@@ -739,12 +741,13 @@ static bool sci_port_is_wide(struct isci_port *iport)
 }
 
 /**
+ * sci_port_link_detected()
  * This method is called by the PHY object when the link is detected. if the
  *    port wants the PHY to continue on to the link up state then the port
  *    layer must return true.  If the port object returns false the phy object
  *    must halt its attempt to go link up.
- * @sci_port: The port associated with the phy object.
- * @sci_phy: The phy object that is trying to go link up.
+ * @iport: The port associated with the phy object.
+ * @iphy: The phy object that is trying to go link up.
  *
  * true if the phy object can continue to the link up condition. true Is
  * returned if this phy can continue to the ready state. false Is returned if
@@ -817,10 +820,8 @@ static void port_timeout(struct timer_list *t)
 
 /* --------------------------------------------------------------------------- */
 
-/**
+/*
  * This function updates the hardwares VIIT entry for this port.
- *
- *
  */
 static void sci_port_update_viit_entry(struct isci_port *iport)
 {
@@ -874,7 +875,7 @@ static void sci_port_suspend_port_task_scheduler(struct isci_port *iport)
 
 /**
  * sci_port_post_dummy_request() - post dummy/workaround request
- * @sci_port: port to post task
+ * @iport: port to post task
  *
  * Prevent the hardware scheduler from posting new requests to the front
  * of the scheduler queue causing a starvation problem for currently
@@ -899,10 +900,11 @@ static void sci_port_post_dummy_request(struct isci_port *iport)
 }
 
 /**
+ * sci_port_abort_dummy_request()
  * This routine will abort the dummy request.  This will alow the hardware to
  * power down parts of the silicon to save power.
  *
- * @sci_port: The port on which the task must be aborted.
+ * @iport: The port on which the task must be aborted.
  *
  */
 static void sci_port_abort_dummy_request(struct isci_port *iport)
@@ -923,8 +925,8 @@ static void sci_port_abort_dummy_request(struct isci_port *iport)
 }
 
 /**
- *
- * @sci_port: This is the struct isci_port object to resume.
+ * sci_port_resume_port_task_scheduler()
+ * @iport: This is the struct isci_port object to resume.
  *
  * This method will resume the port task scheduler for this port object. none
  */
@@ -1014,8 +1016,8 @@ static void sci_port_invalidate_dummy_remote_node(struct isci_port *iport)
 }
 
 /**
- *
- * @object: This is the object which is cast to a struct isci_port object.
+ * sci_port_ready_substate_operational_exit()
+ * @sm: This is the object which is cast to a struct isci_port object.
  *
  * This method will perform the actions required by the struct isci_port on
  * exiting the SCI_PORT_SUB_OPERATIONAL. This function reports
@@ -1186,9 +1188,9 @@ static enum sci_status sci_port_hard_reset(struct isci_port *iport, u32 timeout)
 }
 
 /**
- * sci_port_add_phy() -
- * @sci_port: This parameter specifies the port in which the phy will be added.
- * @sci_phy: This parameter is the phy which is to be added to the port.
+ * sci_port_add_phy()
+ * @iport: This parameter specifies the port in which the phy will be added.
+ * @iphy: This parameter is the phy which is to be added to the port.
  *
  * This method will add a PHY to the selected port. This method returns an
  * enum sci_status. SCI_SUCCESS the phy has been added to the port. Any other
@@ -1257,9 +1259,9 @@ enum sci_status sci_port_add_phy(struct isci_port *iport,
 }
 
 /**
- * sci_port_remove_phy() -
- * @sci_port: This parameter specifies the port in which the phy will be added.
- * @sci_phy: This parameter is the phy which is to be added to the port.
+ * sci_port_remove_phy()
+ * @iport: This parameter specifies the port in which the phy will be added.
+ * @iphy: This parameter is the phy which is to be added to the port.
  *
  * This method will remove the PHY from the selected PORT. This method returns
  * an enum sci_status. SCI_SUCCESS the phy has been removed from the port. Any
-- 
2.27.0

