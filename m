From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][RFC] iSCSI transport class
Date: Tue, 30 Mar 2004 13:02:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4069E04C.2010102@cs.wisc.edu>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA2gVe7Un3YUak/sHlj1pNxAEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:7690 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261204AbUC3VCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 16:02:24 -0500
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA2gVe7Un3YUak/sHlj1pNxAEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net

Hey Surekha,

Thanks for the comments.

Surekha.PC wrote:
>  Hi Mike,
> 
>  I have reviewed your changes for iSCSI transport class. The changes look
> fine.
>  I have few suggestions on further improvements. The attributes can be
> organised
>  under iSCSI transport class in the following structure.
> 
> # ls /sys/class/iscsi_transport/*
> 
>   /* iSCSI host specific attributes */
>   |-- shutdown
>   |-- host_id
>   |-- ....

The examples you placed here are not tranport specific. They are
just HBA values, and should stay under the host attributes.

Also, the host layout here does not look right. What happens when I
have multiple HBAs?

>   /* iSCSI target specific attributes */
>   |-- 1:0:1/
>            |-- target_addr
>            |-- target_name
>            |-- target_port
>            |-- ....

I agree these would be nice under a target attribute. Did
you have something to post since the last time we talked,
or did you write the example by hand?


>   /* lun specific attributes */
>   |-- 1:0:1:0/
>              |-- device -> ../../../devices/platform/iscsi/1:0:0:0
>              |-- driver -> ../../../bus/scsi/drivers/sd
>              |-- lun_status
>              |-- ....

I don't think anything in lun_status is iscsi specific.

>  This way the relevant attributes can be used from respective paths.
> 

I get your point (you just chose the above attributes based on
name to accentuate this right). However, in your example it seems
like you would want to show the parent-children relationships like
here:

/sys/class/iscsi_transport_host
|-- host1
|   |-- a_host_attribute
|   |-- 1:0:1
|   |   |-- target_name
|   |   |-- 1:0:1:0
|   |   |   |- some_lun_attribute

Or you could also do something like

/sys/class/iscsi_transport_host
|-- host1
|   |- a_host_attribute
|   |- 1:0:1 -> ../iscsi_transport_target/1:0:1
|   `- 1:0:2 -> ../iscsi_transport_target/1:0:2
/sys/class/iscsi_transport_target
|-- 1:0:1
|   |- target_name
|   |- ../iscsi_transport_lun/1:0:1:0
........

Making /sys/class/iscsi_transport the parent for everything just
does not look right.


Mike

