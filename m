From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: move entirely over to correct transport class
	formulation
Date: Tue, 28 Mar 2006 09:28:58 -0600
Message-ID: <1143559739.3353.13.camel@mulgrave.il.steeleye.com>
References: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
	 <20060328053902.GA15968@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25580 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751016AbWC1P3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:29:02 -0500
In-Reply-To: <20060328053902.GA15968@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-03-27 at 21:39 -0800, Mike Anderson wrote:
> I did a git pull from the aic tree and scsi-misc, and applied your patch.
> Was scsi_sas_internal.h suppose to be in this patch?

Oh, wait, git cockup ... it won't diff new files.  This is
scsi_sas_internal.h

James

#ifndef _SCSI_SAS_INTERNAL_H
#define _SCSI_SAS_INTERNAL_H

#define SAS_HOST_ATTRS		0
#define SAS_PORT_ATTRS		17
#define SAS_RPORT_ATTRS		7
#define SAS_END_DEV_ATTRS	3
#define SAS_EXPANDER_ATTRS	7

struct sas_internal {
	struct scsi_transport_template t;
	struct sas_function_template *f;
	struct sas_domain_function_template *dft;

	struct class_device_attribute private_host_attrs[SAS_HOST_ATTRS];
	struct class_device_attribute private_phy_attrs[SAS_PORT_ATTRS];
	struct class_device_attribute private_rphy_attrs[SAS_RPORT_ATTRS];
	struct class_device_attribute private_end_dev_attrs[SAS_END_DEV_ATTRS];
	struct class_device_attribute private_expander_attrs[SAS_EXPANDER_ATTRS];

	struct transport_container phy_attr_cont;
	struct transport_container rphy_attr_cont;
	struct transport_container end_dev_attr_cont;
	struct transport_container expander_attr_cont;

	/*
	 * The array of null terminated pointers to attributes
	 * needed by scsi_sysfs.c
	 */
	struct class_device_attribute *host_attrs[SAS_HOST_ATTRS + 1];
	struct class_device_attribute *phy_attrs[SAS_PORT_ATTRS + 1];
	struct class_device_attribute *rphy_attrs[SAS_RPORT_ATTRS + 1];
	struct class_device_attribute *end_dev_attrs[SAS_END_DEV_ATTRS + 1];
	struct class_device_attribute *expander_attrs[SAS_EXPANDER_ATTRS + 1];
};
#define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)

#endif


