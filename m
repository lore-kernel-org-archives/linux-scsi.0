From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 0/8] aic94xx: sas code clean-up
Date: Tue, 9 May 2006 23:53:42 -0700 (PDT)
Message-ID: <20060510065342.40733.qmail@web31807.mail.mud.yahoo.com>
References: <1147209211.11847.33.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:2960 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750910AbWEJGxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 02:53:46 -0400
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> These patches were created in response to the comments from this earlier
> email: 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114624643916659&w=2
> 
> First off, thank you Christoph for your comments.  I am working to
> address them, starting with the ones that are easiest to implement.
> Follows is a set of patches that address the following concerns:
> 
> 1) Move the sas readme to the Documents dir-- this still needs to be
> written so that it 'matches reality', but I want to merge the sas*.h

Which "reality" is this?  Christoph's?

Anyway, the SAS Stack has seen quite a lot of updates, more than I can
list here.  Some of them are
 - Error Recovery,
 - device lifetimes wholly dependent on kobject references,
 - SAS transport layer retries,
 - SAS 2.0 (as much as is available),
 - SAS domain consistency (pathways, port augmentation, route tables
   of augmented ports, etc, etc),
 - SAS versioning: the interconnect declares what SAS version it supports
   and this is what the SAS Stack drives.
 - etc, etc, etc.

The aic94xx driver has also seen changes:
 - versioning,
 - NCQ error handling,
 - bugfixes on recovery, TMFs, etc.

A SAT Layer (SATL) has also been added to the SAS Stack.  It conforms
to the SAT spec, and uses the SAS task infrastructure.  SATL supports
the interconnect SATA features: the interconnect declares the SATA features
it supports, SATL drives them and so configures SATA devices found on the
domain.  NCQ is naturally supported.  Other interesting features are
things like MODE SELECT and READ/WRITE LONG 10/16.  5 VPD pages.
Error recovery (NCQ as well).  All size-version of commands, i.e.
6/10/12/16 as are defined in the appropriate specs.

This is more or less an enterprise effort.

The version from which Bottomley started is old. In contrast it did
support hot-plugging as the announcement on lkml and lsml said.  Now
Bottomley is saying that "it [hotplug] still doesn't work".

I cannot imagine a customer wanting enterprise reliability,
quality and support (as well as technical know-how), to just use
the version you're pushing.

It just boggles my mind... seeing how much more complex storage
is becoming.

This is why I asked "which reality" in the beginning of this message.

Good luck to everyone,
       Luben

> files to libsas.h and sas.h first
> 2) Remove the sas_common.c file
> 3) Remove the //depot SCM comments
> 4) Remove the expander_conf.c from the kernel tree
> 5) Remove various inline functions
> 6) Move list_each_entry_reverse_safe from sas_discover.h to list.h
> 7) Remove the long queue implementation comment
> 8) Use bitops for setting and clearing bits
> 
> These patches are just a start and I will continue to address these
> issues.
> 
> Regards,
> 
> Alexis
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

