From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] scsi_transport_iscsi.c contexts
Date: Wed, 27 Apr 2005 20:11:05 -0700
Message-ID: <42705449.1030706@us.ibm.com>
References: <1114646147.20844.37.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:32509 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261837AbVD1DLR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 23:11:17 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j3S3BDLg122950
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 23:11:13 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3S3BCtY370286
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 21:11:13 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j3S3BCUV003112
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 21:11:12 -0600
In-Reply-To: <1114646147.20844.37.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Nicholas A. Bellinger wrote:
> This patch against 2.6.12-rc3 is the first step for scsi_transport_iscsi
> getting iSCSI Keys defined in RFC 3720 Section 12 and other values not
> defined in this section as keys, but need to be exported out via sysfs
> into the correct connection/session contexts.
> 
> Currently, scsi_transport_iscsi.[c,h] assume that all values are on a
> per session basis.  These changes have been tested with the upcoming
> iSCSI transport class enabled release of iscsi-initiator-core
> (1.6.2.0-rc2), and should hopefully be 'breakage-free' with sfnet.
> 
> Comments?
> 
> 
> 
> ------------------------------------------------------------------------
> 
> diff -urN linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c
> --- linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 15:02:03.000000000 -0700
> +++ linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 17:36:20.000000000 -0700
> @@ -3,6 +3,8 @@
>   *
>   * Copyright (C) IBM Corporation, 2004
>   * Copyright (C) Mike Christie, 2004
> + * Copyright (C) PyX Technologies, 2005
> + * Copyright (C) Nicholas A. Bellinger <nab@kernel.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -25,7 +27,8 @@
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_iscsi.h>
>  
> -#define ISCSI_SESSION_ATTRS 20
> +#define ISCSI_CONNECTION_ATTRS 9
> +#define ISCSI_SESSION_ATTRS 15
>  #define ISCSI_HOST_ATTRS 2
>  
>  struct iscsi_internal {
> @@ -34,6 +37,7 @@
>  	/*
>  	 * We do not have any private or other attrs.
>  	 */
> +	struct class_device_attribute *connection_attrs[ISCSI_CONNECTION_ATTRS + 1];

How are these attrs getting set up? By the LLD? Patch does not work for me;
nothing shows up btw.

The reason all the settings are stuck on the session was becuase we couldn't
come to an agreement on the layout. We wanted to do something like this:

/sys/class/iscsi_session/iscsi_connection

or even

/sys/class/iscsi_session
/sys/class/iscsi_connection

with some symlinks to glue them together for the latter (I could probably do a better
picture but you get the idea right). It depends on if people allowed us to stick kobjects
in structs to make the dirs (could use a attribute group too I guess) or if they wanted
seperate devices. It might make some sense to figure out the layout while seperating
things out.

