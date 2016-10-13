From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Patch: Revert commit
 3e22760d4db6fd89e0be46c3d132390a251da9c6 due to performance issues
Date: Thu, 13 Oct 2016 14:55:29 +0200
Message-ID: <20161013125529.ki6c2oxp4ue5oc32@linux-x5ow.site>
References: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com>
 <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
 <1476197489.4019.68.camel@localhost.localdomain>
 <1476286016.4019.105.camel@localhost.localdomain>
 <000ebf71-9b7a-e6f6-ff8f-0f06eeef64fa@suse.de>
 <1564904000.1465519.1476321625269.JavaMail.zimbra@redhat.com>
 <2049046384.1533310.1476362610308.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2049046384.1533310.1476362610308.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bud Brown <bubrown-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ewan Milne <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Curtis Taylor (cjt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)" <cjt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 08:43:30AM -0400, Laurence Oberman wrote:
> =

> =

> Hello
> =

> This patch reverts commit 3e22760d4db6fd89e0be46c3d132390a251da9c6.
> =

> This revert came about because of efforts by Ewan Milne, Curtis Taylor an=
d I.
> In researching this issue, significant performance issues were seen on la=
rge CPU count =

> systems using the software FCOE stack.
> Hannes also weighed in.
> =

> The same was not apparent on much smaller low count CPU systems.
> The behavior introduced by commit 3e22760d4db6fd89e0be46c3d132390a251da9c=
6 lands sup with large
> count CPU systems seeing continual blk_requeue_request() calls due to ML_=
QUEUE_HOST_BUSY.
> =

> From Ewan:
> =

> fc_exch_alloc() used to try all the available exchange managers in the
> list for an available exchange id, but this was changed in 2010 so that
> if the first matched exchange manager couldn't allocate one, it fails
> and we end up returning host busy.  This was due to commit:
> =

> Setting the ddp_min module parameter to fcoe to 128MB prevents the ->match
> function from permitting the use of the offload exchange manager for the =
frame,
> and we no longer see the problem with host busy status, since it uses the
> larger non-offloaded pool.
> =

> Reverting commit 3e22760d4db6fd89e0be46c3d132390a251da9c6 was tested to a=
lso
> prevent the host busy issue due to failing allocations.
> =

> Suggested-by: Ewan Milne <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Curtis Taylor <cjt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =


Acked-by: Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
