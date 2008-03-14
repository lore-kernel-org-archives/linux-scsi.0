From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Bug in the scsi_id (0.9 version) utility
Date: Thu, 13 Mar 2008 23:08:31 -0700
Message-ID: <20080314060831.GA18884@linux.vnet.ibm.com>
References: <alpine.LRH.1.00.0803130824450.30028@ss.netgate.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60383 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYCNGL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2008 02:11:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.00.0803130824450.30028@ss.netgate.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brooks@netgate.net
Cc: linux-hotplug@vger.kernel.org, Brian.Fehling@citrix.com, xen@netgate.net, cases.634568.7962_21175.de8b732451@cases.netsuite.com, linux-scsi <linux-scsi@vger.kernel.org>

adding a linux-scsi cc as others may have comments on checking of reserved
fields.

brooks@netgate.net <brooks@netgate.net> wrote:
>
> The utility makes the assumption that a reserved field in the 
> identification descriptor returned by a SCSI page 83 response will be 
> filled with "0x00". The Solaris iSCSI target implemenation (and possibly 
> others) instead fills the field with "0XFF". As a result the utility 
> assumes that the Solaris target is a SCSI-2 device and (incorrectly) parses 
> the response as such. The Solaris box actually uses the latest released 
> SCSI command set (SPC3):
>
>     http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf
>
> The fix was simple, check for 0x00 and for 0xFF instead of checking for 
> !0x00. Since this code is generally only used discovery discovery it's a 
> low risk change.
>
> As I understand it there's nothing in the SPC2/3 spec that states that 
> "0x00" should be written to the reserved field of the identification 
> descriptor so I'm not sure this is the best way to determine the device 
> type command set. 

The SAM definitions section and the SPC Keywords section provides a
definition of what should be in a reserved field.

That said we are not required to be checking the reserved fields for zero
but in this case we are doing so to work around another device issue.

Instead of adding yet another device work around to the "if" which
makes it hard to rework the code in the future as you do not know how many
vendor, models are running through certain non compliant checks (i.e. more
than the intend models may exhibit like behavior).

We possible should look at updating how we handle not compliant behavior.
scsi_id.config is available but that must not be useful in all cases as
the standard page 83 code has a check for the pre-spc3-83 case even though
it is selectable through the config file and command line. 

> But, if it's the best we have I guess all we can do is 
> accomodiate the various implementations.  Below is the diff patch made 
> against the 118 code set (0.9 version of the "scsi_id" util).
>
> Please let me know if there is a better way to reort the bug and if this 
> will be an accepted change.  This bug is currently affecting XenSource 
> (Citrix) 4.1 (still in beta).  Xen (4.1) uses the utility to determine the 
> SCSIid of the target for later use in multipath attachement.
>
> Thank you,
> Kevin
>
> ----------------------------------------------------------------
> Kevin Brooks                                    NetGate Internet
> http://www.netgate.net                          iStrata Inc
> ----------------------------------------------------------------
>
>
> --- scsi_serial.c       2008-03-13 08:50:16.000000000 -0700
> +++ scsi_serial_patched.c       2008-03-13 08:46:09.000000000 -0700
> @@ -590,9 +590,18 @@
>          * 0x006048.
>          */
>
> -       if (page_83[6] != 0)
> -               return check_fill_0x83_prespc3(dev_scsi, page_83, 
> id_search_list,
> -                                              serial, serial_short, len);
> +       /*
> +        * Kevin Brooks patch for Solaris iSCSI target devices that
> +        * return something other than 0x00 in the reserved field
> +        * of the reserved field of the identification descriptor
> +        * of the SCSI page 83 response.  Incorrectly parsing this
> +        * causes the device to be incorrectly identified as as a
> +        * SCSI-2 and (incorrectly) parses the response as such.
> +        * The Solaris iSCSI target implementation (and possibly
> +         * others) instead fills the field with 0XFF.
> +        */
> +
> +       if (page_83[6] == 0x00 || page_83[6] == 0xff) {
>
>         /*
>          * Search for a match in the prioritized id_search_list.
> @@ -623,6 +632,13 @@
>                         }
>                 }
>         }
> +
> +       } else {
> +
> +               return check_fill_0x83_prespc3(dev_scsi, page_83, 
> id_search_list,
> +                                              serial, serial_short, len);
> +       }
> +
>         return 1;
>  }

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
