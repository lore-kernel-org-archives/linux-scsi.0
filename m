From: Laurence Oberman <loberman@redhat.com>
Subject: Re: linux-4.8-rc1/drivers/scsi/sd.c:317: pointless test ?
Date: Mon, 8 Aug 2016 16:17:26 -0400 (EDT)
Message-ID: <1029353111.181631.1470687446200.JavaMail.zimbra@redhat.com>
References: <CAMzoamaVuMxuXO8F3pxeR671eKAH-BZyxVDqU2F8jujHepK+5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34968 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbcHHUSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 16:18:31 -0400
In-Reply-To: <CAMzoamaVuMxuXO8F3pxeR671eKAH-BZyxVDqU2F8jujHepK+5w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Binderman <linuxdev.baldrick@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin petersen <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dcb314@hotmail.com



----- Original Message -----
> From: "David Binderman" <linuxdev.baldrick@gmail.com>
> To: jejb@linux.vnet.ibm.com, "martin petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Linux
> Kernel Mailing List" <linux-kernel@vger.kernel.org>, dcb314@hotmail.com
> Sent: Monday, August 8, 2016 9:46:53 AM
> Subject: linux-4.8-rc1/drivers/scsi/sd.c:317: pointless test ?
> 
> Hello there,
> 
> linux-4.8-rc1/drivers/scsi/sd.c:317]: (style) Unsigned variable 'val'
> can't be negative so it is unnecessary to test it.
> 
> Source code is
> 
>     if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
> 
> but
> 
>    unsigned int val;
> 
> Suggest new code
> 
>     if (val <= SD_DIF_TYPE3_PROTECTION)
> 
> Regards
> 
> David Binderman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello

Declaring val as unsigned does not prevent it from being assigned a negative integer.
This means there is a possibility it could be negative.
However looking at the code it seems that we are converting char *buf (string) to an int to set val here.
Also the kernel code shows we cannot have a - sign anyway so I expect your suggestion should be fine to change this.

static ssize_t
protection_type_store(struct device *dev, struct device_attribute *attr,
                      const char *buf, size_t count)
{
        struct scsi_disk *sdkp = to_scsi_disk(dev);
        unsigned int val;
        int err;

        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;

        err = kstrtouint(buf, 10, &val);   *****

        if (err)
                return err;

        if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
                sdkp->protection_type = val;
Reviewed-by
Laurence Oberman <loberman@redhat.com>
        return count;
}

/**
 * kstrtouint - convert a string to an unsigned int
 * @s: The start of the string. The string must be null-terminated, and may also
 *  include a single newline before its terminating null. The first character
 *  may also be a plus sign, but not a minus sign.
 * @base: The number base to use. The maximum supported base is 16. If base is
 *  given as 0, then the base of the string is automatically detected with the
 *  conventional semantics - If it begins with 0x the number will be parsed as a
 *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
 *  parsed as an octal number. Otherwise it will be parsed as a decimal.
 * @res: Where to write the result of the conversion on success.
 *
 * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
 * Used as a replacement for the obsolete simple_strtoull. Return code must
 * be checked.
 */
int kstrtouint(const char *s, unsigned int base, unsigned int *res)
{
        unsigned long long tmp;
        int rv;

        rv = kstrtoull(s, base, &tmp);
        if (rv < 0)
                return rv;
        if (tmp != (unsigned long long)(unsigned int)tmp)
                return -ERANGE;
        *res = tmp;
        return 0;
}

