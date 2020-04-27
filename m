Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3184C54FCB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC621206CD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="l516sYEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgD0PIh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:08:37 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:44634 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD0PIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 11:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588000110; i=@ts.fujitsu.com;
        bh=Rq9kKJvJ+KUnaBACdIqakOgXHaMKu+Gez2U2aQLL1ME=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=l516sYEGIkEbfuxnNt/fu0YTQwI2dG5RbsTKZ+WomcygrsR0l+xX+DQi78PPiXdJ2
         U3OIo+pJgALlpP11O2jphM1Xen8gbyhGxrNtzQBFeKpivcvoUUfiXG3XXKwqXsLOMK
         ATbz9KQVRmbDgFD3cvs0dbh3BzHRZCpoHCHj7aCGRjCkCjQVdWKlvwkVVjMu0i5oTj
         u7rZemaVQX3+lvvhYFxpANmQra2dmbXABBghOr8QpNnzgJgnAEc2eLI2egXUB8hspd
         1/AQyqqoYRdF5J1tPt7vLF/ThXdG+a6sxSFqUiVs/cuXDlY3b/Ml3VRHnp5+ySaDYW
         RjvZerwriW1Aw==
Received: from [100.113.6.103] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 45/00-40390-E65F6AE5; Mon, 27 Apr 2020 15:08:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRWlGSWpSXmKPExsViZ8MxVTfv67I
  4g31veSy+/p/OYrFy9VEmi+7rO9gslh//x2Sx/sgGRovWpW+ZHNg8dt9sYPP4+PQWi8f7fVfZ
  PDafrvb4vEkugDWKNTMvKb8igTVj+adzbAVH1CoePLzB3MDYr9jFyMUhJDCZUaKhfQIThDOdU
  eLvv4XMXYycHGwCBhIrJt1nAbFFBGwk+g4vBStiFmhilLj1aj0bSEJYIELi2KN3QAkODhYBVY
  nN3+tBwrwCdhKzN35nBbElBOQlOg5MBpvDKWAvcebidTaQciGgmo8P9CYwci9gZFjFaJFUlJm
  eUZKbmJmja2hgoGtoaKxromtkpJdYpZukl1qqm5yaV1KUCJTUSywv1iuuzE3OSdHLSy3ZxAgM
  qpRCFrEdjLPWvtc7xCjJwaQkynty9bI4Ib6k/JTKjMTijPii0pzU4kOMMhwcShK8Uz8D5QSLU
  tNTK9Iyc4ABDpOW4OBREuFN+AKU5i0uSMwtzkyHSJ1iVJQS57UDSQiAJDJK8+DaYFF1iVFWSp
  iXkYGBQYinILUoN7MEVf4VozgHo5Iw7yyQ7TyZeSVw018BLWYCWlwlvxhkcUkiQkqqgcn977l
  WhphdJQq5X2Sn39Pe94Nhx+l3H41kF9obVGpL177eIyj65cdrK4PUfb80GDwimayKV2s/fX32
  M7NDQ8XkH/enrDwm8PHb3zDmGSK/TeOf3fzspNeRdK9o97TjWSGcWcmXloosbVyXV2z0bIfUD
  ebkmH0Ru8+27etTTOb4d9Pp+Nf1551WnfmTpdH140v3pPSoOZFB8572dYhFqVutPpeS9uZl6m
  Tj38cNNDvc7UJrjl09cOZy/AerIzf3pZ/5IcyU633rjU5huftfpWduRduU3ByK54tr8mdzO/f
  Ea2cfc9l9tvfAFa8D7jqTMzP47h/Nk7p3JGXqhVdiL/8Ufr/67Hb2i+Kv7aXH18QqsRRnJBpq
  MRcVJwIADf/LmCUDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-18.tower-238.messagelabs.com!1588000109!62717!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 20793 invoked from network); 27 Apr 2020 15:08:30 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-18.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Apr 2020 15:08:30 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03RF8Qji013128;
        Mon, 27 Apr 2020 16:08:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 124A7208E4;
        Mon, 27 Apr 2020 17:08:26 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, ddiss@suse.de, hch@lst.de,
        martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 4/4] target: tcmu: make pgr_support and alua_support attributes writable
Date:   Mon, 27 Apr 2020 17:08:23 +0200
Message-Id: <20200427150823.15350-5-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently in tcmu reservation commands are handled by core's
pr implementation (default) or completely rejected (emulate_pr
set to 0). We additionally want to be able to do full
reservation handling in userspace. Therefore we need a way to
set the TRANSPORT_FLAG_PASSTHROUGH_PGR.
The inverted flag is displayed by attribute pgr_support.
Since we moved the flag from transport/backend to se_device in
the previous patch, we now can make it changeable per device by
allowing to write the attribute.
The new field transport_flags_changeable in transport/backend
is used to reject writing if not allowed for a backend.

Regarding ALUA we also want to be able to passthrough commands
to userspace in tcmu. Therefore we need
TRANSPORT_FLAG_PASSTHROUGH_ALUA to be changeable, because
by setting it we can switch off all ALUA checks in core. So we
also set TRANSPORT_FLAG_PASSTHROUGH_ALUA in tcmu's
transport_flags_changeable.

Of course, ALUA and reservation handling in userspace will work
only, if session/nexus information is sent to userspace along with
every command. This will be object of a patch series announced
by Mike Christie.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 56 +++++++++++++++++++++++++++++++++--
 drivers/target/target_core_user.c     |  2 ++
 include/target/target_core_backend.h  |  1 +
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 279989e32e64..f04352285155 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1105,6 +1105,32 @@ static ssize_t alua_support_show(struct config_item *item, char *page)
 			flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ? 0 : 1);
 }
 
+static ssize_t alua_support_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	bool flag;
+	int ret;
+
+	if (!(dev->transport->transport_flags_changeable &
+	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
+		pr_err("dev[%p]: Unable to change SE Device alua_support:"
+			" alua_support has fixed value\n", dev);
+		return -EINVAL;
+	}
+
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	if (flag)
+		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_ALUA;
+	else
+		dev->transport_flags |= TRANSPORT_FLAG_PASSTHROUGH_ALUA;
+	return count;
+}
+
 static ssize_t pgr_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
@@ -1114,6 +1140,32 @@ static ssize_t pgr_support_show(struct config_item *item, char *page)
 			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
 }
 
+static ssize_t pgr_support_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	bool flag;
+	int ret;
+
+	if (!(dev->transport->transport_flags_changeable &
+	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
+		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
+			" pgr_support has fixed value\n", dev);
+		return -EINVAL;
+	}
+
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	if (flag)
+		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_PGR;
+	else
+		dev->transport_flags |= TRANSPORT_FLAG_PASSTHROUGH_PGR;
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1146,8 +1198,8 @@ CONFIGFS_ATTR(, unmap_granularity);
 CONFIGFS_ATTR(, unmap_granularity_alignment);
 CONFIGFS_ATTR(, unmap_zeroes_data);
 CONFIGFS_ATTR(, max_write_same_len);
-CONFIGFS_ATTR_RO(, alua_support);
-CONFIGFS_ATTR_RO(, pgr_support);
+CONFIGFS_ATTR(, alua_support);
+CONFIGFS_ATTR(, pgr_support);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 264f19ba8453..b02760b2e9c0 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2618,6 +2618,8 @@ static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
 	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH,
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR |
+	                              TRANSPORT_FLAG_PASSTHROUGH_ALUA,
 	.attach_hba		= tcmu_attach_hba,
 	.detach_hba		= tcmu_detach_hba,
 	.alloc_device		= tcmu_alloc_device,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 959163504f82..f51452e3b984 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -24,6 +24,7 @@ struct target_backend_ops {
 	struct module *owner;
 
 	u8 transport_flags_default;
+	u8 transport_flags_changeable;
 
 	int (*attach_hba)(struct se_hba *, u32);
 	void (*detach_hba)(struct se_hba *);
-- 
2.12.3

