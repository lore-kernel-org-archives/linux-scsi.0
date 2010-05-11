From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/7][RFC] qla4xxx: added Add host attributes to export
 host	information to sysfs.
Date: Tue, 11 May 2010 10:58:46 -0500
Message-ID: <4BE97EB6.6060802@cs.wisc.edu>
References: <20100511075756.GA30505@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40420 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0EKP5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 11:57:43 -0400
In-Reply-To: <20100511075756.GA30505@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On 05/11/2010 02:57 AM, Vikas Chaudhary wrote:
> +struct device_attribute *qla4xxx_host_attrs[] = {
> +	&dev_attr_driver_version,

Are we still supposed to be using the MODULE_VERSION() and 
/sys/module/qla4xxx/version for this? It seems like that was given as a 
review comment for a while, but some drivers have added it and some have 
not.



> +	&dev_attr_fw_version,
> +	&dev_attr_serial_num,
> +	&dev_attr_isp_name,
> +	&dev_attr_fw_state,
> +	&dev_attr_board_id,
> +	&dev_attr_hba_reset,


I think resetting the host should be a common scsi_host sysfs attr in 
scsi_sysfs.c. It seems other drivers have added their own reset host 
files, so I am fine with this if other people are.



> +	&dev_attr_ip_state,

I think this should be a common iscsi sysfs file. If we are going to do 
the userspace lib over that translates driver specifics to a common api 
though, then I am fine with this.
