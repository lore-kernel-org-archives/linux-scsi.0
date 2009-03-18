From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 09:44:49 -0400
Message-ID: <20090318134449.GA19448@mars.virtualiron.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu> <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:41942
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755833AbZCRNpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 09:45:49 -0400
Content-Disposition: inline
In-Reply-To: <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

.. snip.. 
>  static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct scsi_device *sdev;
> +	char buffer[501];

Why '501' ? How did you come up with that number?

> +	int rc;
>  
>  	if (dev->type != &scsi_dev_type)
>  		return 0;
>  
>  	sdev = to_scsi_device(dev);
>  
> -	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
> +	buffer[500] = '\0';

Shouldn't that be buffer[501] ?

> +	rc = format_scsi_modalias(sdev, buffer, 500);
> +	if (rc < 0)
> +		return rc;
> +
> +	add_uevent_var(env, "MODALIAS=%s", buffer);
>  	return 0;
>  }
>  
> @@ -697,8 +745,11 @@ static ssize_t
>  sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct scsi_device *sdev;
> +	ssize_t rc;
> +
>  	sdev = to_scsi_device(dev);
> -	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
> +	rc = format_scsi_modalias(sdev, buf, 500);

Maybe a #define for that magic number?

> +	return rc;
>  }
.. snip ..
>  /* Ignore any prefix, eg. some architectures prepend _ */
>  static inline int sym_is(const char *symbol, const char *name)
>  {
> @@ -736,6 +769,7 @@ static void do_table(void *symval, unsig
>  	size -= id_size;
>  
>  	for (i = 0; i < size; i += id_size) {
> +		memset(alias, '\0', 500);

How about:
memset (alias, 0x0, A_BIG_NUMBER);

