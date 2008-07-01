From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [patch 07/11] zfcp: Cleanup of code in zfcp_aux.c
Date: Tue, 1 Jul 2008 15:44:13 +0200
Message-ID: <200807011544.14178.swen@vnet.ibm.com>
References: <20080630105236.960064000@de.ibm.com> <20080630110059.364138000@de.ibm.com> <20080630225259.GB4727@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:30620 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbYGANox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 09:44:53 -0400
In-Reply-To: <20080630225259.GB4727@osiris.boeblingen.de.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: christof.schmitt@de.ibm.com, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tuesday 01 July 2008 00:52, Heiko Carstens wrote:
> > +static int __init zfcp_device_setup(char *devstr)
> >  {
> > -	char *tmp, *str;
> > -	size_t len;
> > +	char *token;
> > 
> >  	if (!devstr)
> >  		return 0;
> > 
> > -	len = strlen(devstr) + 1;
> > -	str = kmalloc(len, GFP_KERNEL);
> > -	if (!str) {
> > -		pr_err("zfcp: Could not allocate memory for "
> > -		       "device parameter string, device not attached.\n");
> > -		return 0;
> > -	}
> > -	memcpy(str, devstr, len);
> > -
> > -	tmp = strchr(str, ',');
> > -	if (!tmp)
> > +	token = strsep(&devstr, ",");
> > +	if (!token || strlen(token) >= BUS_ID_SIZE)
> >  		goto err_out;
> > -	*tmp++ = '\0';
> > -	strncpy(zfcp_data.init_busid, str, BUS_ID_SIZE);
> > -	zfcp_data.init_busid[BUS_ID_SIZE-1] = '\0';
> > +	strncpy(zfcp_data.init_busid, token, BUS_ID_SIZE);
> > 
> > -	zfcp_data.init_wwpn = simple_strtoull(tmp, &tmp, 0);
> > -	if (*tmp++ != ',')
> > -		goto err_out;
> > -	if (*tmp == '\0')
> > +	token = strsep(&devstr, ",");
> > +	if (!token || strict_strtoull(token, 0, &zfcp_data.init_wwpn))
> >  		goto err_out;
> > 
> > -	zfcp_data.init_fcp_lun = simple_strtoull(tmp, &tmp, 0);
> > -	if (*tmp != '\0')
> > +	token = strsep(&devstr, ",");
> > +	if (!token || strict_strtoull(token, 0, &zfcp_data.init_fcp_lun))
> >  		goto err_out;
> > -	kfree(str);
> >  	return 1;
> > 
> >   err_out:
> >  	pr_err("zfcp: Parse error for device parameter string %s, "
> > -	       "device not attached.\n", str);
> > -	kfree(str);
> > +	       "device not attached.\n", devstr);
> >  	return 0;
> >  }
> 
> Sorry, but this still seems to be incorrect. strsep modifies the string that
> gets passed to it. In this case you let it operate on the original module
> parameter string which is also exported via sysfs.
> So after parsing finished the exported string is much shorter than the
> original string. That was actually the whole point why the old code allocated
> memory and copied the string so the copy could be modified.
> A comment would have been good ;)
> --
Correct,

I fixed the patch and Christof will send it soon to the list.

Cheers Swen

