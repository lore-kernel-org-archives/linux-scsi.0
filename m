From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Wed, 1 Oct 2003 12:34:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031001193438.5021.qmail@web60210.mail.yahoo.com>
References: <3F71C1CA.5030004@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60210.mail.yahoo.com ([216.109.118.105]:33107 "HELO
	web60210.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262353AbTJATej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2003 15:34:39 -0400
In-Reply-To: <3F71C1CA.5030004@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Comments /questions below.
--- Jeff Garzik <jgarzik@pobox.com> wrote:
> jd wrote:
> > Hi,
> > 
> > Available for first Review & Comments.
> > 
> > The UNH iSCSI Project, a collaborative effort between the
> > UNH IOL and Hewlett Packard Company in Austin, Texas,
> > ( hosted at http://sourceforge.net/projects/unh-iscsi )
> > to produce a full feature, generic iSCSI implementation ,
> > has ported the 2.4.18/20 version of the iSCSI initiator to
> > Linux 2.6.test5 Kernel for consideration of inclusion for
> > future distribution.
> > 
> > A patch file is available for review at:
> > 
> > http://www.parisc-linux.org/~jpd/
> > 
> > Files included in the patch :
> > 
> >  drivers/scsi/Makefile
> >  drivers/scsi/Kconfig
> >  drivers/scsi/unh_iscsi
> >  drivers/scsi/unh_iscsi/initiator     # HBA & Data mover
> >  drivers/scsi/unh_iscsi/common        # Login and shared files
> >  drivers/scsi/unh_iscsi/security       $ SRP and CHAP login
> > 
> > Please submit comments to :
> > 
> > linux-scsi@vger.kernel.org
> 
> Please don't mangle or otherwise use non-RFC email addresses.  When
> you 
> use your normal email address somewhere in the email _anyway_, you're
> 
> annoying valid users while doing nothing to defeat spammers.
  
 Yes, there seems to be no way to avoid their trash. It took
 them no time to spam this account after a couple of posts.
> 
> 
> comments:
> 
> * use generic facility for crc32

   We will.
> 
> * most of the formatting looks good, but some of it looks crazy, like
> 
> > +	add_length = scan_table_and_process(sock,
> > +										p_param_tbl,
> > +										SECURITY_PARAM | INFORMATIONAL_PARAM,
> > +										INITIATOR,
> > +										inputpdu,
> > +										outputpdu,
> > +										connection_flags, login_flags);
> 
> * indeed, this needs to be legible to people w/ 80-column screens

    We're working that. Eventually it will be a much cleaner file.
> 
> * I disagree with the need for "my_kmalloc" and "my_kfree".  Ditch
> the 
> allocator and directly use the kernel counterparts.
   We use it for debug to find memory leaks and fix them,
   not as a generally garbage collector. We're likely
   wrap it them in a DEBUG phrase or something better it 
   certainly has helped. 
> 
> * function prototypes should use "u32" not "__u32" forms.  Ditto for 
> other kernel-internal structures.

  I'm not quite sure about this one. I see 
  the majority of scsi code uses int,uint .
  Are you recommending just a more consistent usage ?

  
> 
> * string_llx is not needed.  use sprintf.
   Yes.
> 
> * verbosely dumping scsi ops is something that should be more generic
> 
> (or removed)
> 
> * authentication should be offloaded to a daemon, as NFSv4 did
> 
   It will be .
> * I got tired of scrolling right to read code, at this point
> 


 Thanks.


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
